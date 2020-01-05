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
            case MULTIBOOT2_TAG_TYPE_MMAP:
            {
                X64.mmap = kmalloc(sizeof(struct mem_regions));
                X64.mmap->chain_length = 0;

                struct mem_regions *creg = NULL;
                for (multiboot2_memory_map_t *mmap = ((struct multiboot2_tag_mmap*)tag)->entries;
                    (uintptr_t)mmap < ((uintptr_t)tag + tag->size);
                    mmap = (multiboot2_memory_map_t*)((uintptr_t)mmap + ((struct multiboot2_tag_mmap*)tag)->entry_size))
                {
                    if (creg == NULL)
                        creg = X64.mmap;
                    else
                    {
                        struct mem_regions *creg_new = kmalloc(sizeof(struct mem_regions));
                        creg->next = creg_new;
                        creg = creg_new;
                    }

                    creg->start = mmap->addr;
                    creg->size = mmap->len;

                    switch (mmap->type)
                    {
                        case MULTIBOOT2_MEMORY_AVAILABLE:
                            creg->attrib = MEM_REGION_AVAILABLE | MEM_REGION_MAPPED | MEM_REGION_READ | MEM_REGION_WRITE;
                            break;
                        case MULTIBOOT2_MEMORY_RESERVED:
                            creg->attrib = MEM_REGION_PROTECTED;
                            break;
                        case MULTIBOOT2_MEMORY_ACPI_RECLAIMABLE:
                            creg->attrib = MEM_REGION_PROTECTED | MEM_REGION_MAPPED | MEM_REGION_READ | MEM_REGION_WRITE;
                            break;
                        case MULTIBOOT2_MEMORY_NVS:
                            creg->attrib = MEM_REGION_PRESERVE | MEM_REGION_MAPPED | MEM_REGION_READ | MEM_REGION_WRITE;
                            break;
                        case MULTIBOOT2_MEMORY_BADRAM:
                            creg->attrib = MEM_REGION_BAD | MEM_REGION_MAPPED | MEM_REGION_PROTECTED;
                            break;
                    }
                }
                break;
            }
        }
    }

    return 0;
}