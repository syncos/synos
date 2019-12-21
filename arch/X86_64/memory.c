#include <synos/synos.h>
#include <synos/arch/multiboot2.h>
#include <inttypes.h>
#include <synos/arch/io.h>
#include <string.h>
#include "memory.h"
#include "interrupts/interrupts.h"

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
    PT_0[0]   = 0;
    PT_0[0]  |= PAGE_PRESENT | PAGE_NO_EXECUTE;
    // MBR (used during core bootup) (0x7000 - 0x8000)
    PT_0[7]   = 0x7000;
    PT_0[7]  |= PAGE_PRESENT | PAGE_WRITABLE /* Needed to be able to write boot code for the cores*/ | PAGE_NO_EXECUTE;
    // EBDA + ROM
    for (int i = 0; i < 128; ++i)
    {
        PT_0[80 + i]  = 0x80000 + (0x1000 * i);
        PT_0[80 + i] |= PAGE_PRESENT | PAGE_NO_EXECUTE;
    }
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

    pm_lowmem_fill(); // Set page map for low mem

    return 0;
}

boot_t bootdata;
extern uint32_t mbp;
extern uint32_t mbm;
extern uint8_t mb2;
extern bool mboot2Init(uint32_t addr, uint32_t magic, boot_t* mb2Data);

#ifdef MEM_MANUAL_PROBE
static uint64_t mem_probe()
{
    panic("Manual probing currently not supported. Please use the multiboot standard instead.");

    IRQ_save();
    IRQ_kill();

    register uintptr_t *mem;
    uint64_t mem_count, a;
    //uint16_t memkb;
    uint64_t cr0;

    mem_count = 0;
    //memkb = 0;

    // Save a copy of cr0
    asm volatile ("movq %0, cr0" : "=r"(cr0));
    // Invalidate the cache
    asm volatile ("wbinvd");

    IRQ_restore();

    return mem_count;
}
#endif

struct MEMID* getMEMID(struct MEMID* mem)
{
    if (mb2 == 1 && mbm != MULTIBOOT2_BOOTLOADER_MAGIC)
    {
        mem->enabled = false;
        return mem;
    }
    mem->enabled = true;

    if (mb2 == 1)
    {
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
    }
    else
    {
        #ifndef MEM_MANUAL_PROBE
        panic("System was not booted with multiboot or multiboot2. The system must resort to manual probing, but is prohibited. To allow manual memory probing, change 'MEMORY_ALLOW_MANUAL_PROBE' to 'TRUE' in arch/X86_64/.config and recompile.");
        #else
        mem->totalSize = mem_probe();
        #endif
    }

    return mem;
}