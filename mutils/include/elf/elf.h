#ifndef _ELF_H
#define _ELF_H
#include <stddef.h>
#include <stdint.h>

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

    E_TYPE0 = 0,
    E_TYPE1,

    E_MACHINE0 = 0,
    E_MACHINE1,
    
    E_VERSION0 = 0,
    E_VERSION1,
    E_VERSION2,
    E_VERSION3,

    E_ENTRY0 = 0,
    E_ENTRY1,
    E_ENTRY2,
    E_ENTRY3,
    #ifdef _64BIT_
    E_ENTRY4,
    E_ENTRY5,
    E_ENTRY6,
    E_ENTRY7,
    #endif

    E_PHOFF0 = 0,
    E_PHOFF1,
    E_PHOFF2,
    E_PHOFF3,
    #ifdef _64BIT_
    E_PHOFF4,
    E_PHOFF5,
    E_PHOFF6,
    E_PHOFF7,
    #endif

    E_SHOFF0 = 0,
    E_SHOFF1,
    E_SHOFF2,
    E_SHOFF3,
    #ifdef _64BIT_
    E_SHOFF4,
    E_SHOFF5,
    E_SHOFF6,
    E_SHOFF7,
    #endif

    E_FLAGS0 = 0,
    E_FLAGS1,
    E_FLAGS2,
    E_FLAGS3,

    E_EHSIZE0 = 0,
    E_EHSIZE1,

    E_PHENTSIZE0 = 0,
    E_PHENTSIZE1,

    E_PHNUM0 = 0,
    E_PHNUM1,

    E_SHENTSIZE0 = 0,
    E_SHENTSIZE1,

    E_SHNUM0 = 0,
    E_SHNUM1,

    E_SHSTRNDX0 = 0,
    E_SHSTRNDX1
};
struct ELF_HEADER
{
    char* header;
    size_t header_length;

    char* e_ident;

    char* e_type;
    uint16_t *e_type_16;

    char* e_machine;
    uint16_t *e_machine_16;

    char* e_version;
    uint32_t *e_version_32;

    char* e_entry;
    uintptr_t *e_entry_ptr;

    char* e_phoff;
    uintptr_t *e_phoff_ptr;

    char* e_shoff;
    uintptr_t *e_shoff_ptr;

    char* e_flags;
    uint32_t *e_flags_32;

    char* e_ehsize;
    uint16_t *e_ehsize_16;

    char* e_phentsize;
    uint16_t *e_phentsize_16;

    char* e_phnum;
    uint16_t *e_phnum_16;

    char* e_shentsize;
    uint16_t *e_shentsize_16;

    char* e_shnum;
    uint16_t *e_shnum_16;

    char* e_shstrndx;
    uint16_t *e_shstrndx_16;
};

struct ELF_OBJ
{
    char* FILE;
    size_t FILE_LENGTH;

    struct ELF_HEADER* header;
};

struct ELF_OBJ *ParseELF(const char*, const size_t);
struct ELF_HEADER *ParseELF_HEADER(const char*);

bool FileIsELF(const char*);

#endif