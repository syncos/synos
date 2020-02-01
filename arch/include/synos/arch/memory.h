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
extern const size_t virt_page_size;

struct MEMID* getMEMID(struct MEMID*);

int pga_init();
void pga_map(void *vaddress, uintptr_t paddress, unsigned int order, unsigned int flags);
void pga_unmap(void *vaddress, unsigned int order);
uintptr_t pga_getPhysAddr(void *vaddress);
bool pga_ispresent(void *vaddress);

struct mem_regions;

void mem_p_protect(struct mem_regions *region);
struct mem_regions *get_regions();

#endif