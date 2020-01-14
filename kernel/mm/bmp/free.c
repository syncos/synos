#include <synos/mm.h>
#include <spinlock.h>
#include "bmp.h"

void page_free(mregion_t *region, uintptr_t phaddr)
{
    spinlock_lock(&region->lock);
    if (phaddr < region->start || phaddr >= region->start + region->size)
        return;
    
    size_t offset = (phaddr - region->start) / page_size;
    page_clear(region, offset);
    if (offset < ((bmp_map_t *)region->page_alloc_si)->pointer_offset)
        ((bmp_map_t *)region->page_alloc_si)->pointer_offset = offset;
    spinlock_unlock(&region->lock);
}
void pages_free(mregion_t *region, uintptr_t phaddr, unsigned int order)
{
    spinlock_lock(&region->lock);
    if (phaddr < region->start || phaddr >= region->start + region->size)
        return;
    
    size_t offset = (phaddr - region->start) / page_size;
    for (size_t i = offset; i < offset + ORDER(order); ++i)
        page_clear(region, i);
    if (offset < ((bmp_map_t *)region->page_alloc_si)->pointer_offset)
        ((bmp_map_t *)region->page_alloc_si)->pointer_offset = offset;
    spinlock_unlock(&region->lock);
}