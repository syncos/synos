#ifndef ARCH_CPU_H
#define ARCH_CPU_H
#include <inttypes.h>

struct CPUID
{
    
};
// Basic memory information (3.6.3)
typedef struct
{
    bool enabled;

    u32 upper;
    u32 lower;
}bmi_t;
// BIOS Boot device (3.6.4)
typedef struct
{
    bool enabled;

    u32 biosdev;
    u32 partition;
    u32 sub_partition;
}BBd_t;
// Boot command line (3.6.5)
typedef struct
{
    bool enabled;

    u32 size;
    u32 stringSize;
    char* string;
}BCL_t;
// Modules (3.6.6)
typedef struct
{
    bool enabled;

    u32 size;
    u32 mod_start;
    u32 mod_end;
    u32 stringSize;
    char* string;
}MDS_t;
// ELF-Symbols (3.6.7)
typedef struct
{
    bool enabled;

    u32 size;
    u16 num;
    u16 entsize;
    u16 shndx;
    u16 reserved;
}ELFs_t;
// Memory map (3.6.8)
typedef struct
{
    bool enabled;
    u64 base_addr;
    u64 length;
    u32 type;
    u32 reserved;
}MM_entries_t;
typedef struct
{
    bool enabled;

    u32 size;
    u32 entry_size;
    u32 entry_version;

    u64 sEntries;
    u64 nEntries;
    MM_entries_t* mem_entries;
}MM_t;
// Multiboot2 information data structure
typedef struct
{
    u32 total_size;
    u32 reserved;

    bmi_t bmi;
    BBd_t BBd;
    BCL_t BCL;
    MDS_t MDS;
    ELFs_t ELFs;
    MM_t MM;
}mboot2_t;
#endif