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

enum mem_regions_attributes
{
    MEM_REGION_READ         = (1 << 0),
    MEM_REGION_WRITE        = (1 << 1),
    MEM_REGION_PROTECTED    = (1 << 2),
    MEM_REGION_MAPPED       = (1 << 3),
    MEM_REGION_BAD          = (1 << 4),
    MEM_REGION_PRESERVE     = (1 << 5),
    MEM_REGION_AVAILABLE    = (1 << 6),
};
typedef struct mem_regions
{
    uintptr_t start;
    uintptr_t size;
    uint8_t attrib;

    uint32_t chain_length;
    struct mem_regions *next;
}mregion_t;

extern const size_t phys_page_size;
extern const size_t phys_page_count;
extern uint8_t phys_page_bmp[];

struct MEMID* getMEMID(struct MEMID*);

int pga_init();
struct mem_regions get_regions();

#endif