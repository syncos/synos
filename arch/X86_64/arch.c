#include <synos/arch/arch.h>
#include <synos/synos.h>
#include <string.h>
#include "x64.h"
#include "memory.h"

enum LOAD_SYSTEMS load_sys;
struct BootInfo X64;

#include <elf/elf.h>
void tab_search()
{
    if (X64.sections.elf_sh == NULL || X64.sections.elf_sh_length == 0)
        return;
    
    X64.symbols.elf_sym = NULL;
    X64.symbols.elf_str = NULL;

    X64.symbols.elf_sym_size = 0;
    X64.symbols.elf_str_size = 0;

    for (uint32_t i = 1; (X64.symbols.elf_sym == 0 || X64.symbols.elf_str == 0) && i < X64.sections.elf_sh_length; ++i)
    {
        if (X64.symbols.elf_sym == 0 && X64.sections.elf_sh[i].sh_type == SHT_SYMTAB)
        {
            X64.symbols.elf_sym_size = X64.sections.elf_sh[i].sh_size;
            X64.symbols.elf_sym = kmalloc(X64.symbols.elf_sym_size);
            memcpy(X64.symbols.elf_sym, (void*)X64.sections.elf_sh[i].sh_addr, X64.symbols.elf_sym_size);
        }
        else if (X64.symbols.elf_str == 0 && X64.sections.elf_sh[i].sh_type == SHT_STRTAB)
        {
            X64.symbols.elf_str_size = X64.sections.elf_sh[i].sh_size;
            X64.symbols.elf_str = kmalloc(X64.symbols.elf_str_size);
            memcpy(X64.symbols.elf_str, (void*)X64.sections.elf_sh[i].sh_addr, X64.symbols.elf_str_size);
        }
    }
}

#include "multiboot.h"
extern int mbootInit();
static void load_sys_detect()
{
    extern uint32_t mbm;
    switch (mbm)
    {
        case MULTIBOOT_BOOTLOADER_MAGIC:
            mbootInit();
            return;
        default:
            panic("System booted with invalid load system. Please make sure you boot with multiboot");
            return;
    }
}

int arch_init()
{
    load_sys_detect();
    // Configure the TSS
    initTSS();
    // Configure and load the GDT
    initGDT();
    return 0;
}