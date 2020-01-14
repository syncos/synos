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

const size_t page_size = 4096;
const size_t virt_page_size = 4096;

uint64_t  PML_4_Table[512] __attribute__((aligned(4096)));
uint64_t* PML_4 = &PML_4_Table[0];

// Initial lower tables
uint64_t PDP_0[512] __attribute__((aligned(4096)));
uint64_t PD_0 [512] __attribute__((aligned(4096)));
uint64_t PT_0 [512] __attribute__((aligned(4096)));

static void pm_lowmem_fill()
{
    // Protect low-memory

    // Start by filling the first 256 entries
    for (int i = 0; i < 256; ++i)
    {
        PT_0[i]  = 0x1000 * i;
        PT_0[i] |= PAGE_PRESENT | PAGE_WRITABLE;
    }

    // IVT + BDA (0x0000 - 0x1000)
    PT_0[0]  |= PAGE_PRESENT | PAGE_NO_EXECUTE;
    // MBR (used during core bootup) (0x7000 - 0x8000)
    PT_0[7]  |= PAGE_PRESENT | PAGE_WRITABLE /* Needed to be able to write boot code for the cores */ | PAGE_NO_EXECUTE;
    // EBDA + ROM
    for (int i = 0; i < 128; ++i)
    {
        PT_0[80 + i] |= PAGE_PRESENT | PAGE_NO_EXECUTE;
    }
}

void mem_v_alloc()
{
    
}

static void kern_mem_map()
{
    // Map kernel code segment
    uintptr_t code_pages = (uintptr_t)__KERN_CODE_SIZE / virt_page_size;
    if ((uintptr_t)__KERN_CODE_SIZE % virt_page_size != 0)
        ++code_pages;

    for (unsigned int offset = 0; offset < code_pages; ++offset)
    {
        PT_0[(0x100000 / virt_page_size) + offset]  = 0;
        PT_0[(0x100000 / virt_page_size) + offset]  = 0x100000 + (4096 * offset);
        PT_0[(0x100000 / virt_page_size) + offset] |= PAGE_PRESENT;
    }

    // Map kernel data segment
    uintptr_t data_pages = (uintptr_t)__KERN_DATA_SIZE / virt_page_size;
    if ((uintptr_t)__KERN_DATA_SIZE % virt_page_size)
        ++data_pages;

    for (unsigned int offset = 0; offset < data_pages; ++offset)
    {
        PT_0[((uintptr_t)__KERN_CODE_START / virt_page_size) + offset]  = 0;
        PT_0[((uintptr_t)__KERN_CODE_START / virt_page_size) + offset]  = (uintptr_t)__KERN_CODE_START + (4096 * offset);
        PT_0[((uintptr_t)__KERN_CODE_START / virt_page_size) + offset] |= PAGE_PRESENT | PAGE_WRITABLE | PAGE_NO_EXECUTE;
    }

    // Map kernel memory stack
    extern uintptr_t MemStack;
    uintptr_t stack_pages = (MemStack - (uintptr_t)__KERN_MEM_END) / virt_page_size;
    if ((MemStack - (uintptr_t)__KERN_MEM_END) % virt_page_size != 0)
        ++stack_pages;
    
    for (unsigned int offset = 0; offset < stack_pages; ++offset)
    {
        PT_0[((uintptr_t)__KERN_DATA_END / virt_page_size) + offset]  = 0;
        PT_0[((uintptr_t)__KERN_DATA_END / virt_page_size) + offset]  = (uintptr_t)__KERN_DATA_END + (4096 * offset);
        PT_0[((uintptr_t)__KERN_DATA_END / virt_page_size) + offset] |= PAGE_PRESENT | PAGE_WRITABLE | PAGE_NO_EXECUTE;
    }
}

int pga_init()
{
    // Initialize memory controller
    memset(PML_4, 0, 8*512); // Clear to-be PML_4 table

    // Link PDP_0 to PML_4
    PML_4[0]  = (uint64_t)&PDP_0[0];
    PML_4[0] |= PAGE_PRESENT | PAGE_WRITABLE;

    // Link PD_0 to PDP_0
    PDP_0[0]  = (uint64_t)&PD_0[0];
    PDP_0[0] |= PAGE_PRESENT | PAGE_WRITABLE;

    // Link PT_0 to PD_0
    PD_0[0]   = (uint64_t)&PT_0[0];
    PD_0[0]  |= PAGE_PRESENT | PAGE_WRITABLE;

    return 0;
}
void pga_enable()
{
    asm volatile ("mov cr3, rax" :: "r" (PML_4));
}

void pga_map(uintptr_t vaddress, uintptr_t paddress, size_t length, unsigned int flags)
{
    unsigned int pml4_idx = (vaddress >> 39) & 511;
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