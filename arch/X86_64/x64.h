#ifndef _X64_H
#define _X64_H
#include <inttypes.h>
#include <elf/elf.h>
#include <synos/arch/memory.h>

enum LOAD_SYSTEMS
{
    MULTIBOOT,
    MULTIBOOT2
};
extern enum LOAD_SYSTEMS load_sys;

struct BootInfo
{
    struct 
    {
        struct ELF64_Sym *elf_sym;
        uint32_t elf_sym_size;
        char* elf_str;
        uint32_t elf_str_size;
    }symbols;
    struct
    {
        struct ELF64_Shdr *elf_sh;
        uint32_t elf_sh_length;
    }sections;

    struct mem_regions *mmap;
};

extern struct BootInfo X64;

#endif