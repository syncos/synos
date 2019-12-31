#include <inttypes.h>
#include <synos/arch/arch.h>
#include <synos/synos.h>
#include "memory.h"
#include "x64.h"
#include "multiboot2.h"

extern uint32_t mbm;
extern uint32_t mbp;

extern void tab_search();

int mboot2Init()
{
    if (mbm != MULTIBOOT2_BOOTLOADER_MAGIC)
        panic("System not booted with multiboot2 standard. mboot2Init() still invoked (possible kernel bug).");
    load_sys = MULTIBOOT2;

    X64.symbols.elf_sym = NULL;
    X64.symbols.elf_str = NULL;

    X64.symbols.elf_sym_size = 0;
    X64.symbols.elf_str_size = 0;

    X64.sections.elf_sh = NULL;
    X64.sections.elf_sh_length = 0;

    struct multiboot2_tag *tag;
    for (tag = (struct multiboot2_tag*)(uintptr_t)(mbp + 8); tag->type != MULTIBOOT2_TAG_TYPE_END; tag = (struct multiboot2_tag *) ((multiboot2_uint8_t *) tag + ((tag->size + 7) & ~7)))
    {
        switch (tag->type)
        {
            case MULTIBOOT2_TAG_TYPE_ELF_SECTIONS:
            {
                X64.sections.elf_sh = (struct ELF64_Shdr *)((struct multiboot2_tag_elf_sections*)tag)->sections;
                X64.sections.elf_sh_length = ((struct multiboot2_tag_elf_sections*)tag)->num;
                tab_search();
                break;
            }
        }
    }

    return 0;
}