#ifndef ARCH_MEMORY_H
#define ARCH_MEMORY_H
#include <inttypes.h>

struct MEMID
{
    bool enabled;

    uint64_t nEntries;
    MM_entries_t* entries;
};

struct MEMID getMEMID();
#endif