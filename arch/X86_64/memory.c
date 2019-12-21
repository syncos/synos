#include <synos/synos.h>
#include <synos/arch/multiboot2.h>
#include <inttypes.h>
#include <synos/arch/io.h>
#include <string.h>
#include "memory.h"

extern volatile uintptr_t __KERN_MEM_START[];
extern volatile uintptr_t __KERN_MEM_END[];
extern volatile uintptr_t __KERN_MEM_SIZE[];
const uintptr_t _MemStart = (uintptr_t)__KERN_MEM_START;
const uintptr_t _MemEnd   = (uintptr_t)__KERN_MEM_END;
const uintptr_t _MemSize  = (uintptr_t)__KERN_MEM_SIZE;

uint64_t  PML_4_Table[512] __attribute__((aligned(4096)));
uint64_t* PML_4 = &PML_4_Table[0];

// Initial lower tables
uint64_t PDP_0[512] __attribute__((aligned(4096)));
uint64_t PD_0 [512] __attribute__((aligned(4096)));
uint64_t PT_0 [512] __attribute__((aligned(4096)));

void* kmalloc(size_t bytes)
{
    #ifdef MEMSTACK_ENABLE
    if (!System.MMU_enabled)
    {
        return memstck_malloc(bytes);
    }
    #else
    if (!System.MMU_enabled)
    {
        return NULL;
    }
    #endif
    return NULL;
}
int memc_init()
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

    // Protect low-memory
    // IVT + BDA
    PT_0[0]   = 0;
    PT_0[0]  |= PAGE_PRESENT | PAGE_NO_EXECUTE;

    return 0;
}

boot_t bootdata;
extern uint32_t mbp;
extern uint32_t mbm;
extern bool mboot2Init(uint32_t addr, uint32_t magic, boot_t* mb2Data);

struct MEMID* getMEMID(struct MEMID* mem)
{
    if (mbm != MULTIBOOT2_BOOTLOADER_MAGIC)
    {
        mem->enabled = false;
        return mem;
    }
    mem->enabled = true;

    if(!mboot2Init(mbp, mbm, &bootdata) || !bootdata.MM.enabled)
    {
        mem->enabled = false;
        return mem;
    }

    mem->enabled = true;
    mem->nEntries = bootdata.MM.nEntries;
    mem->entries = bootdata.MM.mem_entries;

    mem->totalSize = 0;
    for (size_t i = 0; i < mem->nEntries; i++)
    {
        mem->totalSize += bootdata.MM.mem_entries[i].length;
    }

    return mem;
}