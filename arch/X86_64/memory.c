#include <synos/synos.h>
#include <synos/arch/multiboot2.h>
#include <inttypes.h>
#include <synos/arch/io.h>

#ifndef PRINTF_FALLBACK
const bool PRINTF_FB_ENABLE = false;
#endif

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

    return mem;
}