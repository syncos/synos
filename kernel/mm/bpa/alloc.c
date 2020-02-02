#include <synos/mm.h>
#include <spinlock.h>
#include "bpa.h"

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
uintptr_t page_alloc(mregion_t *region)
{
    return pages_alloc(region, 0);
}

uintptr_t pages_reserve(mregion_t *region, unsigned int order, uint64_t offset)
{
    spinlock_lock(&region->lock);
    bpa_map_t *map = region->page_alloc_si;
    
    if (!block_check(region, order, offset))
    {
        block_set(region, order, offset);
        --map->pages_free[order];
        if (map->next_free_page[order] == offset)
            map->next_free_page[order] = find_next_free_page(region, order, offset+1);
        spinlock_unlock(&region->lock);
        return (BLOCK_ORDER_SIZE(order) * offset) + region->start;
    }
    size_t p_offset = offset & ~(1UL);
    unsigned int split_order_start = order;
    for (unsigned int i = order+1; i < MAX_ORDER; ++i)
    {
        p_offset /= 2;
        if (!block_check(region, i, p_offset)) {
            split_order_start = i;
            break;
        }
    }
    for (unsigned int i = split_order_start; i > order; --i)
    {
        zblock_split(region, i, p_offset);
        p_offset *= 2;
    }
    block_set(region, order, offset);
    --map->pages_free[order];
    if (map->next_free_page[order] == offset)
        map->next_free_page[order] = find_next_free_page(region, order, offset+1);

    spinlock_unlock(&region->lock);
    return (BLOCK_ORDER_SIZE(order) * offset) + region->start;
}