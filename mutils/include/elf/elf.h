#ifndef _ELF_H
#define _ELF_H
#include <stddef.h>
#include <stdint.h>

typedef uint16_t ELF32_uint16_t, ELF64_uint16_t;
typedef uint32_t ELF32_uint32_t, ELF32_uintptr_t, ELF64_uint32_t;

typedef uint64_t ELF64_uintptr_t;

enum HEADER_FIELDS
{
    EI_MAG0 = 0,
    EI_MAG1,
    EI_MAG2,
    EI_MAG3,

    EI_CLASS,
    EI_DATA,
    EI_VERSION,
    EI_OSABI,
    EI_ABIVERSION,
};
struct ELF_HEADER
{
    char* header;
    size_t header_length;

    char* e_ident;

    uint16_t e_type;
    uint16_t e_machine;
    uint32_t e_version;
    uintptr_t e_entry;
    uintptr_t e_phoff;
    uintptr_t e_shoff;
    uint32_t e_flags;
    uint16_t e_ehsize;
    uint16_t e_phentsize;
    uint16_t e_phnum;
    uint16_t e_shentsize;
    uint16_t e_shnum;
    uint16_t e_shstrndx;
};

struct ELF_PROGRAM_HEADER
{
    char* header;
    size_t header_length;

    uint32_t p_type;
    uint32_t p_flags;
    uintptr_t p_offset;
    uintptr_t p_vaddr;
    uintptr_t p_paddr;
    uintptr_t p_filesz;
    uintptr_t p_memsz;
    uintptr_t p_align;
};

struct ELF_SECTION_HEADER
{
    uint32_t sh_name;
    uint32_t sh_type;

    uintptr_t sh_flags;
    uintptr_t sh_addr;
    uintptr_t sh_offset;
    uintptr_t sh_size;

    uint32_t sh_link;
    uint32_t sh_info;

    uintptr_t sh_addralign;
    uintptr_t sh_entsize;
};

struct ELF_OBJ
{
    char* FILE;
    size_t FILE_LENGTH;

    struct ELF_HEADER *header;
    struct ELF_PROGRAM_HEADER* program_headers; // The length of this array is defined in header->e_phnum
    struct ELF_SECTION_HEADER* section_headers; // The length of this array is defined in header->e_shnum
};

enum Section_Types
{
    SHT_NULL,
    SHT_PROGBITS,
    SHT_SYMTAB,
    SHT_STRTAB,
    SHT_RELA,
    SHT_HASH,
    SHT_DYNAMIC,
    SHT_NOTE,
    SHT_NOBITS,
    SHT_REL,
    SHT_SHLIB,
    SHT_DYNSUM,
};
struct ELF32_Shdr
{
    ELF32_uint32_t  sh_name;
    ELF32_uint32_t  sh_type;
    ELF32_uint32_t  sh_flags;
    ELF32_uintptr_t sh_addr;
    ELF32_uint32_t  sh_offset;
    ELF32_uint32_t  sh_size;
    ELF32_uint32_t  sh_link;
    ELF32_uint32_t  sh_info;
    ELF32_uint32_t  sh_addralign;
    ELF32_uint32_t  sh_entsize;
};
struct ELF64_Shdr
{
    ELF64_uint32_t  sh_name;
    ELF64_uint32_t  sh_type;
    ELF64_uint32_t  sh_flags;
    ELF64_uintptr_t sh_addr;
    ELF64_uint32_t  sh_offset;
    ELF64_uint32_t  sh_size;
    ELF64_uint32_t  sh_link;
    ELF64_uint32_t  sh_info;
    ELF64_uint32_t  sh_addralign;
    ELF64_uint32_t  sh_entsize;
};

struct ELF32_Sym
{
    ELF32_uint32_t  st_name;
    ELF32_uintptr_t st_value;
    ELF32_uint32_t  st_size;
    unsigned char   st_info;
    unsigned char   st_other;
    ELF32_uint16_t  st_shndx;
};
struct ELF64_Sym
{
    ELF64_uint32_t  st_name;
    ELF64_uintptr_t st_value;
    ELF64_uint32_t  st_size;
    unsigned char   st_info;
    unsigned char   st_other;
    ELF64_uint16_t  st_shndx;
};

struct ELF_OBJ *ParseELF(const char*, const size_t);

struct ELF_HEADER *ParseELF_HEADER(const char*);
struct ELF_PROGRAM_HEADER* ParseELF_PRG_HEADER(const struct ELF_HEADER*, char*);
struct ELF_SECTION_HEADER* ParseELF_SCT_HEADER(const struct ELF_HEADER*, char*);

bool FileIsELF(const char*);

#endif