#ifndef MM_BPA_H
#define MM_BPA_H
#include <inttypes.h>
#include <stddef.h>
#include <synos/mm.h>

#define MAX_ORDER 10
#define BITS_PER_PAGE 2

#define ORDER(ord) (1 << ord)
#define MAX_ORDER_COUNT (1 << MAX_ORDER)
#define BLOCK_ORDER_SIZE(order) (page_size * (1 << order))

typedef struct bpa_map
{
    size_t pages;
    size_t free_area_size;
    void *free_area[MAX_ORDER];
    size_t pages_free[MAX_ORDER];
    size_t next_free_page[MAX_ORDER];
}bpa_map_t;

void block_split(mregion_t *region, unsigned int order);
void zblock_split(mregion_t *region, unsigned int order, size_t offset);
void block_merge(mregion_t *region, unsigned int order, size_t offset);
void out_of_mem(mregion_t *region);

static inline bool block_check(mregion_t *region, unsigned int order, size_t offset)
{
    bpa_map_t *map = region->page_alloc_si;
    return (((char*)map->free_area[order])[offset/8] >> (offset%8)) & 1U;
}
static inline void block_set(mregion_t *region, unsigned int order, size_t offset)
{
    bpa_map_t *map = region->page_alloc_si;
    if (!block_check(region, order, offset))
        --region->pages_free;
    ((char*)map->free_area[order])[offset/8] |= (1 << (offset%8));
}
static inline void block_clear(mregion_t *region, unsigned int order, size_t offset)
{
    bpa_map_t *map = region->page_alloc_si;
    if (block_check(region, order, offset))
        ++region->pages_free;
    ((char*)map->free_area[order])[offset/8] &= ~(1 << (offset%8));
}
static inline void blocks_set(mregion_t *region, unsigned int order, size_t offset_start, size_t length)
{
    for (size_t i = offset_start; i < offset_start + length; ++i)
        block_set(region, order, i);
}
static inline void blocks_clear(mregion_t *region, unsigned int order, size_t offset_start, size_t length)
{
    for (size_t i = offset_start; i < offset_start + length; ++i)
        block_clear(region, order, i);
}
static inline size_t free_area_length(mregion_t *region, unsigned int order)
{
    size_t length = ((bpa_map_t *)region->page_alloc_si)->pages;
    for (unsigned int i = 0; i < order; ++i)
        length = length / 2;
    return length;
}
static inline unsigned int order_max(mregion_t *region)
{
    unsigned int order;
    size_t length = ((bpa_map_t *)region->page_alloc_si)->pages;
    for (order = 0; order < MAX_ORDER; ++order) 
    {
        if (length % 2)
            return order;
        length /= 2;
    }

    return MAX_ORDER - 1;
}
static inline size_t find_next_free_page(mregion_t *region, unsigned int order, size_t start)
{
    for (size_t i = start; i < free_area_length(region, order); ++i)
    {
        if (!block_check(region, order, i))
            return i;
    }
    bpa_map_t *map = region->page_alloc_si;
    map->pages_free[order] = 0;
    return 0;
}

#endif