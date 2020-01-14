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

extern const size_t page_size;

struct MEMID* getMEMID(struct MEMID*);

int pga_init();
void pga_enable();
void pga_map(uintptr_t vaddress, uintptr_t paddress, size_t length, unsigned int flags);
bool pga_ispresent(void *vaddress);

void mem_v_alloc();
void mem_p_alloc();

struct mem_regions *get_regions();

#endif