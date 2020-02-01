#include "bpa.h"
#include <synos/mm.h>
#include <spinlock.h>
#include <string.h>

const size_t mm_sb_size = sizeof(bpa_map_t);
const size_t bits_per_page = BITS_PER_PAGE;

static void _free_area_map(mregion_t *region)
{
    size_t start_addr = region->start;
    unsigned int order = order_max(region);
    for (size_t i = 0; i < free_area_length(region, order); ++i)
    {
        if (start_addr >= region->start + region->size || (region->start + region->size) - start_addr < BLOCK_ORDER_SIZE(order))
        {
            blocks_set(region, order, i, free_area_length(region, order) - i);
            return;
        }
        start_addr += BLOCK_ORDER_SIZE(order);
        ++((bpa_map_t*)region->page_alloc_si)->pages_free[order];
    }
    for (signed long i = order - 1; i >= 0; --i)
        blocks_set(region, (unsigned int)i, 0, free_area_length(region, (unsigned int)i));
}

void region_map(mregion_t *region, size_t pages, void *sb, void *pageent)
{
    spinlock_lock(&region->lock);
    region->page_alloc_si = sb;
    bpa_map_t *map = sb;
    map->pages = pages;
    map->free_area_size = ((pages * BITS_PER_PAGE) + (8 - 1)) / 8;
    region->pages_total = pages;
    region->pages_free = pages;
    region->mem_full = false;

    memset(pageent, 0, map->free_area_size);
    memset(map->pages_free, 0, sizeof(size_t)*MAX_ORDER);
    memset(map->next_free_page, 0, sizeof(size_t)*MAX_ORDER);
    map->free_area[0] = pageent;

    void *last_pos = pageent;
    size_t last_size = (pages + (8 - 1)) / 8;
    for (int i = 1; i < MAX_ORDER; ++i)
    {
        last_pos += last_size;
        map->free_area[i] = last_pos;
        last_size = (last_size + 1) / 2;
    }
    _free_area_map(region);
    spinlock_unlock(&region->lock);
}

void out_of_mem(mregion_t *region)
{
    region->mem_full = true;
}

void block_split(mregion_t *region, unsigned int order)
{
    if (order == 0 || order >= MAX_ORDER)
        return;
    bpa_map_t *map = region->page_alloc_si;
    ord_check:
    if (map->pages_free[order] > 0)
    {
        block_set(region, order, map->next_free_page[order]);
        block_clear(region, order-1, map->next_free_page[order]*2);
        block_clear(region, order-1, map->next_free_page[order]*2+1);

        if (map->next_free_page[order-1] > map->next_free_page[order]*2)
            map->next_free_page[order-1] = map->next_free_page[order]*2;
        map->pages_free[order-1] += 2;
        
        if (map->pages_free[order] != 1)
            map->next_free_page[order] = find_next_free_page(region, order, ++map->next_free_page[order]);
        else
            map->next_free_page[order] = 0;
        --map->pages_free[order];

        return;
    }
    if (order == MAX_ORDER - 1)
    {
        out_of_mem(region);
        return;
    }
    block_split(region, order+1);
    if (map->pages_free[order] == 0)
    {
        out_of_mem(region);
        return;
    }
    goto ord_check;
}
void zblock_split(mregion_t *region, unsigned int order, size_t offset)
{
    if (order == 0 || order >= MAX_ORDER)
        return;
    
    bpa_map_t *map = region->page_alloc_si;
    if (!block_check(region, order, offset))
    {
        pos:
        block_set(region, order, offset);
        block_clear(region, order-1, offset*2);
        block_clear(region, order-1, offset*2+1);

        if (map->next_free_page[order-1] > map->next_free_page[order]*2)
            map->next_free_page[order-1] = map->next_free_page[order]*2;
        map->pages_free[order-1] += 2;

        if (map->pages_free[order] != 1)
            map->next_free_page[order] = find_next_free_page(region, order, ++map->next_free_page[order]);
        else
            map->next_free_page[order] = 0;
        --map->pages_free[order];

        return;
    }
    if (order == MAX_ORDER - 1)
        return;
    zblock_split(region, order+1, offset/2);
    if (!block_check(region, order, offset))
        goto pos;
    return;
}
void block_merge(mregion_t *region, unsigned int order, size_t offset)
{
    if (order >= MAX_ORDER - 1)
        return;
    
    bpa_map_t *map = region->page_alloc_si;
    offset &= ~(1UL);

    block_set(region, order, offset);
    block_set(region, order, offset + 1);
    block_clear(region, order+1, offset/2);

    map->pages_free[order] -= 2;
    ++map->pages_free[order+1];

    if (map->next_free_page[order] == offset || map->next_free_page[order] == offset + 1)
        map->next_free_page[order] = find_next_free_page(region, order, offset + 2);
    if (map->next_free_page[order+1] > offset/2)
        map->next_free_page[order+1] = offset/2;
    
    if (!block_check(region, order+1, (offset/2) + 1))
        block_merge(region, order+1, offset/2);
}