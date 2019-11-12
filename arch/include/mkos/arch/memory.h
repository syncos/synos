#ifndef ARCH_MEMORY_H
#define ARCH_MEMORY_H
#include <mkos/arch/arch.h>
#include <inttypes.h>

struct MEMID
{
    bool enabled;

    uint64_t nEntries;
    MM_entries_t* entries;
};

struct MEMID* getMEMID(struct MEMID*);

#ifdef MEMSTACK_ENABLE
extern void* memstck_malloc(size_t bytes);
#endif

#endif