#ifndef ARCH_H
#define ARCH_H
#include <inttypes.h>

extern const uintptr_t _MemStart;
extern const uintptr_t _MemEnd;
extern uintptr_t MemStack;
extern const uintptr_t _MemSize;

/* Boot information structure */
// Basic memory information (3.6.3)
typedef struct
{
    bool enabled;

    uint32_t upper;
    uint32_t lower;
}bmi_t;
// BIOS Boot device (3.6.4)
typedef struct
{
    bool enabled;

    uint32_t biosdev;
    uint32_t partition;
    uint32_t sub_partition;
}BBd_t;
// Boot command line (3.6.5)
typedef struct
{
    bool enabled;

    uint32_t size;
    uint32_t stringSize;
    char* string;
}BCL_t;
// Modules (3.6.6)
typedef struct
{
    bool enabled;

    uint32_t size;
    uint32_t mod_start;
    uint32_t mod_end;
    uint32_t stringSize;
    char* string;
}MDS_t;
// ELF-Symbols (3.6.7)
typedef struct
{
    bool enabled;

    uint32_t size;
    uint16_t num;
    uint16_t entsize;
    uint16_t shndx;
    uint16_t reserved;
}ELFs_t;
// Memory map (3.6.8)
typedef struct
{
    bool enabled;
    uint64_t base_addr;
    uint64_t length;
    uint32_t type;
    uint32_t reserved;
}MM_entries_t;
typedef struct
{
    bool enabled;

    uint32_t size;
    uint32_t entry_size;
    uint32_t entry_version;

    uint64_t sEntries;
    uint64_t nEntries;
    MM_entries_t* mem_entries;
}MM_t;
// Boot information data structure
typedef struct
{
    uint32_t total_size;
    uint32_t reserved;

    bmi_t bmi;
    BBd_t BBd;
    BCL_t BCL;
    MDS_t MDS;
    ELFs_t ELFs;
    MM_t MM;
}boot_t;

#endif