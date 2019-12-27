#include "x64.h"
#include "multiboot.h"
#include <synos/synos.h>
#include <inttypes.h>
#include <elf/elf.h>

struct multiboot_info *mbinf;
extern uint32_t mbm;
extern uint32_t mbp;

extern void tab_search();

int mbootInit()
{
    if (mbm != MULTIBOOT_BOOTLOADER_MAGIC)
        panic("System not booted with multiboot standard. mbootInit() still invoked (possible kernel bug).");
    load_sys = MULTIBOOT;

    mbinf = (struct multiboot_info*)(uint64_t)mbp;

    if (mbinf->flags & MULTIBOOT_INFO_ELF_SHDR)
    {
        X64.sections.elf_sh = (struct ELF64_Shdr*)(uint64_t)mbinf->u.elf_sec.addr;
        X64.sections.elf_sh_length = mbinf->u.elf_sec.num;
        tab_search();
    }
    else
    {
        X64.symbols.elf_sym = NULL;
        X64.symbols.elf_str = NULL;

        X64.symbols.elf_sym_size = 0;
        X64.symbols.elf_str_size = 0;

        X64.sections.elf_sh = NULL;
        X64.sections.elf_sh_length = 0;
    }

    return 0;
}