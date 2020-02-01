#include <synos/mm.h>
#include <spinlock.h>
#include "bpa.h"

void page_free(mregion_t *region, uintptr_t phaddr)
{
    spinlock_lock(&region->lock);
    if (phaddr < region->start || phaddr >= region->start + region->size)
        return;
    
    size_t offset = (phaddr - region->start) / page_size;
    if (!block_check(region, 0, offset))
        return;
    block_clear(region, 0, offset);

    bpa_map_t *map = region->page_alloc_si;
    ++map->pages_free[0];
    if (offset < map->next_free_page[0])
        map->next_free_page[0] = offset;

    size_t buddy = offset;
    if (offset & 1)
        --buddy;
    else
        ++buddy;
    if (!block_check(region, 0, buddy))
        block_merge(region, 0, offset);
    spinlock_unlock(&region->lock);
}
void pages_free(mregion_t *region, uintptr_t phaddr, unsigned int order)
{
    spinlock_lock(&region->lock);
    if (phaddr < region->start || phaddr >= region->start + region->size)
        return;
    size_t offset = (phaddr - region->start) / page_size;
    if (!block_check(region, order, offset))
        return;
    block_clear(region, order, offset);

    bpa_map_t *map = region->page_alloc_si;
    ++map->pages_free[order];
    if (offset < map->next_free_page[order])
        map->next_free_page[order] = offset;
    
    size_t buddy = offset;
    if (offset & 1)
        --buddy;
    else
        ++buddy;
    if (!block_check(region, order, buddy))
        block_merge(region, order, offset);
    spinlock_unlock(&region->lock);
}