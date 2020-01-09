#ifndef MM_BMP_H
#define MM_BMP_H
#include <inttypes.h>

typedef struct bmp_pages
{
    uint8_t bits;
}bmp_pages_t;
typedef struct bmp_map
{
    size_t pages;
    size_t pointer_offset;
    bmp_pages_t* list_pages;
}bmp_map_t;

extern void outofmem(mregion_t *region);

#define ORDER(odr) (1 << odr)
static inline void page_set(mregion_t *region, size_t offset)
{
    ((bmp_map_t *)region->page_alloc_si)->list_pages[offset/8].bits |= (1 << (offset%8));
}
static inline void page_clear(mregion_t *region, size_t offset)
{
    ((bmp_map_t *)region->page_alloc_si)->list_pages[offset/8].bits &= ~(1 << (offset%8));
}
static inline bool page_isfree(mregion_t *region, size_t offset)
{
    return !((((bmp_map_t *)region->page_alloc_si)->list_pages[offset/8].bits >> (offset%8)) & 1U);
}
static inline size_t next_free_page(mregion_t *region, size_t start)
{
    for (size_t i = start; i < ((bmp_map_t *)region->page_alloc_si)->pages; ++i)
    {
        if (page_isfree(region, i))
            return i;
    }
    outofmem(region);
    return 0;
}

#endif