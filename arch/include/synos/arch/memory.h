#ifndef ARCH_MEMORY_H
#define ARCH_MEMORY_H
#include <synos/arch/arch.h>
#include <inttypes.h>

struct MEMID
{
    bool enabled;

    size_t nEntries;
    uintptr_t totalSize;
};

extern const size_t phys_page_size;
extern const size_t phys_page_count;
extern uint8_t phys_page_bmp[];

struct MEMID* getMEMID(struct MEMID*);

int pga_init();
void mem_page_protect();
struct mem_regions *get_regions();

#endif