#include <synos/mm.h>
#include <spinlock.h>
#include "bpa.h"

uintptr_t page_alloc(mregion_t *region)
{
    spinlock_lock(&region->lock);
    bpa_map_t *map = region->page_alloc_si;

    check_ord0:
    if (map->pages_free[0] > 0)
    {
        block_set(region, 0, map->next_free_page[0]);
        uintptr_t phys_addr = (phys_page_size * map->next_free_page[0]) + region->start;

        if (map->pages_free[0] != 1)
            map->next_free_page[0] = find_next_free_page(region, 0, ++map->next_free_page[0]);
        else
            map->next_free_page[0] = 0;
        
        --map->pages_free[0];

        spinlock_unlock(&region->lock);
        return phys_addr;
    }
    block_split(region, 1);
    if (map->pages_free[0] == 0)
    {
        spinlock_unlock(&region->lock);
        return 0;
    }
    goto check_ord0;
}

uintptr_t pages_alloc(mregion_t *region, unsigned int order)
{
    if (order >= MAX_ORDER)
        return 0;
    spinlock_lock(&region->lock);
    bpa_map_t *map = region->page_alloc_si;

    check_ord:
    if (map->pages_free[order] > 0)
    {
        block_set(region, order, map->next_free_page[order]);
        uintptr_t phys_addr = (BLOCK_ORDER_SIZE(order) * map->next_free_page[order]) + region->start;

        if (map->pages_free[order] != 1)
            map->next_free_page[order] = find_next_free_page(region, order, ++map->next_free_page[order]);
        else
            map->next_free_page[order] = 0;
        --map->pages_free[order];

        spinlock_unlock(&region->lock);
        return phys_addr;
    }
    if (order == MAX_ORDER - 1)
    {
        out_of_mem(region);
        spinlock_unlock(&region->lock);
        return 0;
    }
    block_split(region, order + 1);
    if (map->pages_free[order] == 0)
    {
        out_of_mem(region);
        spinlock_unlock(&region->lock);
        return 0;
    }
    goto check_ord;
}

uintptr_t pages_reserve(mregion_t *region, unsigned int order, uint64_t offset)
{
    spinlock_lock(&region->lock);
    bpa_map_t *map = region->page_alloc_si;
    if (offset < map->next_free_page[order] || !block_check(region, order, offset))
    {
        pos:
        block_set(region, order, offset);
        uintptr_t phys_addr = (BLOCK_ORDER_SIZE(order) * offset) + region->start;

        if (map->next_free_page[order] == offset)
            ++map->next_free_page[order];
        --map->pages_free[order];

        spinlock_unlock(&region->lock);
        return phys_addr;
    }
    if (order == MAX_ORDER - 1)
    {
        spinlock_unlock(&region->lock);
        return 0;
    }
    zblock_split(region, order+1, offset/2);
    if (!block_check(region, order, offset))
        goto pos;
    spinlock_unlock(&region->lock);
    return 0;
}