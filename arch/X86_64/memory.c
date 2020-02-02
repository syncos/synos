#include <synos/synos.h>
#include <synos/mm.h>
#include <inttypes.h>
#include <synos/arch/io.h>
#include <string.h>
#include "memory.h"
#include "x64.h"
#include "interrupts/interrupts.h"

const uintptr_t _MemStart = (uintptr_t)__KERN_MEM_START;
const uintptr_t _MemEnd   = (uintptr_t)__KERN_MEM_END;
const uintptr_t _MemSize  = (uintptr_t)__KERN_MEM_SIZE;
extern uint32_t mbp;

const size_t page_size = 4096;
const size_t virt_page_size = 4096;

uintptr_t PML4;
extern void PML4_T();

int pga_init()
{
    PML4 = (uintptr_t)PML4_T;

    // Map the PML4 table to itself, this way we can access all page tables with only the physical address of PML4 mapped to memory
    uint64_t entry = PML4;
    entry |= 0b11;
    *(uint64_t*)(PML4 + (8 * 511)) = entry;

    return 0;
}

static uintptr_t get_table_address(void *address, int level)
{
    uintptr_t table_address = ((uintptr_t)address >> (9*level));
    table_address &= ~(7UL);
    for (int i = 0; i < level; ++i)
        table_address |= (511UL << (39-(9*i)));
    if ((table_address >> 47) & 1U)
        table_address |= (0xFFFFUL << 48);
    else
        table_address &= ~(0xFFFFUL << 48);
    return table_address;
}

bool page_ispresent(void *vaddress, int level)
{
    if (level <= 0 || level > 4)
        return false;
    
    if (level < 4)
        if (!page_ispresent(vaddress, level + 1))
            return false;
    
    uintptr_t table_address = get_table_address(vaddress, level);
    if (*((uint64_t*)table_address) & 1U)
        return true;
    return false;
}
uint64_t page_info(void *vaddress)
{
    if (!page_ispresent(vaddress, 1))
        return 0;
    // We utilize the 511th entry of the PML4 that is mapped to the PML4 table itself to get the information
    uintptr_t pt_address = ((uintptr_t)vaddress >> 9);
    pt_address &= ~(3UL);
    pt_address |= (511UL << 39);

    return *((uint64_t*)pt_address);
}
uintptr_t pga_getPhysAddr(void *vaddress)
{
    uint64_t pinfo = page_info(vaddress);

    pinfo &= ~(0xFFFUL); // Remove everything else except the physical address
    pinfo &= ~(0xFFFUL << 52);

    return pinfo;
}
bool pga_ispresent(void *vaddress)
{
    if (page_ispresent(vaddress, 1))
        return true;
    return false;
}

static bool page_table_alloc(int level, void *offset)
{
    if (level <= 0 || level > 4)
        return false;
    if (level < 4 && !page_ispresent(offset, level + 1))
        page_table_alloc(level + 1, offset);

    uint64_t entry = (uint64_t)alloc_page(GFP_KERNEL);
    entry |= 0b11;
    
    uintptr_t table_address = get_table_address(offset, level);
    
    *((uint64_t*)table_address) = entry;
    return true;
}
void pga_map(void *vaddress, uintptr_t paddress, unsigned int order, unsigned int flags)
{
    uint64_t entry = 0;
    if (!(flags & VPAGE_NOT_PRESENT))
        entry |= 0b1;
    if (!(flags & VPAGE_NOT_WRITABLE))
        entry |= 0b10;
    if (flags & VPAGE_USER_ACCESS)
        entry |= 0b100;
    if (flags & VPAGE_NO_CACHE)
        entry |= 0b1000;
    if (flags & VPAGE_NO_EXECUTE)
        entry |= (1UL << 63);
    for (size_t i = 0; i < (1UL << order); ++i)
    {
        if (!page_ispresent(vaddress + (virt_page_size * i), 2))
            page_table_alloc(2, vaddress + (virt_page_size * i));
        
        entry = (((paddress + (page_size * i)) & ~((0xFFFUL << 52) | 0xFFFUL))) + (entry & ((0xFFFUL << 52) | 0xFFFUL));
        uint64_t table_address = get_table_address(vaddress + (virt_page_size * i), 1);

        *((uint64_t*)table_address) = entry;
    }
}
void pga_unmap(void *vaddress, unsigned int order)
{
    for (size_t i = 0; i < (1UL << order); ++i)
    {
        if (!page_ispresent(vaddress + (virt_page_size * i), 1))
            continue;
        
        uint64_t table_address = get_table_address(vaddress + (virt_page_size * i), 1);

        *((uint64_t*)table_address) = 0;
    }
}

void mem_p_protect(struct mem_regions *region)
{
    if (region->start < 0x200000)
    {
        // Region is part of 0x000000 - 0x200000
        uintptr_t res_size = 0x200000 - region->start;
        if (res_size > region->size)
            res_size = region->size;
        size_t pages = (res_size + (page_size - 1)) / page_size;
        pages_reserve(region, log_order(pages), region->start / page_size);
    }
    if (region->start < mbp + mboot_info_size && region->start + region->size > mbp)
    {
        uintptr_t start = mbp;
        if (region->start >mbp)
            start = region->start;
        uintptr_t res_size = mboot_info_size - (start - mbp);
        if (region->size - (start - region->start) < res_size)
            res_size = region->size - (start - region->start);
        size_t pages = (res_size + (page_size - 1)) / page_size;
        pages_reserve(region, log_order(pages), (start - region->start) / page_size);
    }
}

struct mem_regions *get_regions()
{
    return X64.mmap;
}

extern uint32_t mbp;
extern uint32_t mbm;
extern uint8_t mb2;

struct MEMID* getMEMID(struct MEMID* mem)
{
    if (X64.mmap == NULL)
    {
        mem->enabled = false;
        return mem;
    }

    mem->nEntries = X64.mmap->chain_length;
    mem->totalSize = 0;

    struct mem_regions *creg = X64.mmap;
    for (uint32_t i = 0; i < mem->nEntries; ++i)
    {
        mem->totalSize += creg->size;
        creg = creg->next;
    }

    return mem;
}