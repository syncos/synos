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
        struct mem_regions *creg = NULL;
        for (multiboot_memory_map_t *ent = (multiboot_memory_map_t*)(uintptr_t)mbinf->mmap_addr; (uintptr_t)ent < mbinf->mmap_addr + mbinf->mmap_length; ent += ent->size)
        {
            if (creg == NULL)
                creg = X64.mmap;
            else
            {
                struct mem_regions *creg_new = kmalloc(sizeof(struct mem_regions));
                creg->next = creg_new;
                creg = creg_new;
            }

            creg->start = ent->addr;
            creg->size = ent->len;
            
            creg->attrib = 0;
            if (ent->type & MULTIBOOT_MEMORY_AVAILABLE)
                creg->attrib |= MEM_REGION_AVAILABLE | MEM_REGION_MAPPED | MEM_REGION_READ;
            if (ent->type & MULTIBOOT_MEMORY_RESERVED)
                creg->attrib |= MEM_REGION_PRESERVE | MEM_REGION_PROTECTED | MEM_REGION_READ;
            if (ent->type & MULTIBOOT_MEMORY_ACPI_RECLAIMABLE)
                creg->attrib |= MEM_REGION_PROTECTED | MEM_REGION_READ | MEM_REGION_WRITE;
            if (ent->type & MULTIBOOT_MEMORY_NVS)
                creg->attrib |= MEM_REGION_PRESERVE | MEM_REGION_READ;
            if (ent->type & MULTIBOOT_MEMORY_BADRAM)
                creg->attrib |= MEM_REGION_BAD;

            ++X64.mmap->chain_length;
        }
    }
    else
    {
        X64.mmap = NULL;
    }
    

    return 0;
}