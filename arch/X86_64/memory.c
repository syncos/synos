#include <mkos/mkos.h>
#include <inttypes.h>

boot_t bootdata;
extern uint32_t mbp;
extern uint32_t mbm;
extern bool mboot2Init(uint32_t addr, uint32_t magic, boot_t* mb2Data);

struct MEMID getMEMID()
{
    struct MEMID mem;
    
    if(!mboot2Init(mbp, mbm, &bootdata) || !bootdata.MM.enabled)
    {
        mem.enabled = false;
        return mem;
    }

    mem.enabled = true;
    mem.nEntries = bootdata.MM.nEntries;
    mem.entries = bootdata.MM.mem_entries;

    return mem;
}