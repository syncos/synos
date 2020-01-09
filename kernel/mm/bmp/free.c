#include <synos/mm.h>
#include "bmp.h"

void page_free(mregion_t *region, uintptr_t phaddr)
{
    if (phaddr < region->start || phaddr >= region->start + region->size)
        return;
    
    size_t offset = (phaddr - region->start) / phys_page_size;
    page_clear(region, offset);
    if (offset < ((bmp_map_t *)region->page_alloc_si)->pointer_offset)
        ((bmp_map_t *)region->page_alloc_si)->pointer_offset = offset;
}
void pages_free(mregion_t *region, uintptr_t phaddr, unsigned int order)
{
    if (phaddr < region->start || phaddr >= region->start + region->size)
        return;
    
    size_t offset = (phaddr - region->start) / phys_page_size;
    for (size_t i = offset; i < offset + ORDER(order); ++i)
        page_clear(region, i);
    if (offset < ((bmp_map_t *)region->page_alloc_si)->pointer_offset)
        ((bmp_map_t *)region->page_alloc_si)->pointer_offset = offset;
}