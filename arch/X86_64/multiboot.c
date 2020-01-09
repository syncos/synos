#include "x64.h"
#include "multiboot.h"
#include <synos/synos.h>
#include <synos/mm.h>
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

    mbinf = (struct multiboot_info*)(uintptr_t)mbp;

    if (mbinf->flags & MULTIBOOT_INFO_ELF_SHDR)
    {
        X64.sections.elf_sh_length = mbinf->u.elf_sec.num;
        X64.sections.elf_sh = (struct ELF64_Shdr*)(uintptr_t)mbinf->u.elf_sec.addr;
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

    if (mbinf->flags & MULTIBOOT_INFO_MEM_MAP)
    {
        X64.mmap = kmalloc(sizeof(struct mem_regions));
        X64.mmap->chain_length = 0;
        X64.mmap->page_alloc_start = 0;
        X64.mmap->next = NULL;
        struct mem_regions *creg = NULL;
        for (multiboot_memory_map_t *ent = (multiboot_memory_map_t*)(uintptr_t)mbinf->mmap_addr;
            (uintptr_t)ent < (uintptr_t)mbinf->mmap_addr + (uintptr_t)mbinf->mmap_length;
            ent = (multiboot_memory_map_t*)((uintptr_t)ent + ent->size + sizeof(ent->size))
        )
        {
            if (creg == NULL)
                creg = X64.mmap;
            else
            {
                struct mem_regions *creg_new = kmalloc(sizeof(struct mem_regions));
                creg->next = creg_new;
                creg = creg_new;
                creg->chain_length = 0;
                creg->page_alloc_start = 0;
                creg->next = NULL;
            }

            creg->start = ent->addr;
            creg->size = ent->len;
            
            switch (ent->type)
            {
                case MULTIBOOT_MEMORY_AVAILABLE:
                    creg->attrib = MEM_REGION_AVAILABLE | MEM_REGION_MAPPED | MEM_REGION_READ | MEM_REGION_WRITE;
                    break;
                case MULTIBOOT_MEMORY_RESERVED:
                    creg->attrib = MEM_REGION_PROTECTED;
                    break;
                case MULTIBOOT_MEMORY_ACPI_RECLAIMABLE:
                    creg->attrib = MEM_REGION_PROTECTED | MEM_REGION_MAPPED | MEM_REGION_READ | MEM_REGION_WRITE;
                    break;
                case MULTIBOOT_MEMORY_NVS:
                    creg->attrib = MEM_REGION_PRESERVE | MEM_REGION_MAPPED | MEM_REGION_READ | MEM_REGION_WRITE;
                    break;
                case MULTIBOOT_MEMORY_BADRAM:
                    creg->attrib = MEM_REGION_BAD | MEM_REGION_MAPPED | MEM_REGION_PROTECTED;
                    break;
            }

            ++X64.mmap->chain_length;
        }
    }
    else
    {
        X64.mmap = NULL;
    }
    

    return 0;
}