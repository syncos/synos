#ifndef ARCH_MEMORY_H
#define ARCH_MEMORY_H
#include <synos/arch/arch.h>
#include <inttypes.h>

struct MEMID
{
    bool enabled;

    size_t nEntries;
    uintptr_t totalSize;
    MM_entries_t* entries;
};

struct MEMID* getMEMID(struct MEMID*);

int memc_init();

extern void* kmalloc(size_t bytes);
extern void* kfree(size_t bytes);

#ifdef MEMSTACK_ENABLE
extern void* memstck_malloc(size_t bytes);
extern void* memstck_realloc(void* p, size_t bytes);
#endif

#endif