#include <synos/mm.h>
#include "bmp.h"

uintptr_t page_alloc(mregion_t *region)
{
    page_set(region, ((bmp_map_t *)region->page_alloc_si)->pointer_offset);
    uintptr_t phys_addr = (phys_page_size * ((bmp_map_t *)region->page_alloc_si)->pointer_offset) + region->start;

    ((bmp_map_t *)region->page_alloc_si)->pointer_offset = next_free_page(region, ((bmp_map_t *)region->page_alloc_si)->pointer_offset + 1);

    return phys_addr;
}
uintptr_t pages_alloc(mregion_t *region, unsigned int order)
{
    if (order == 0)
        return page_alloc(region);
    size_t page_start;
    bool nfp_check = true;
    for (size_t i = ((bmp_map_t *)region->page_alloc_si)->pointer_offset; i < ((bmp_map_t *)region->page_alloc_si)->pages - ORDER(order); ++i)
    {
        goto loop;
        skip:
        nfp_check = false;
        continue;
        loop:
        for (size_t t = i; t < i + ORDER(order); ++t)
        {
            if (!page_isfree(region, t))
            {
                goto skip;
            }
        }
        page_start = i;
        goto done;
    }

    // TODO: implement a handler when the function can't find a series of pages long enough to fufill the request
    return 0;

    done:;

    uintptr_t phys_addr = (phys_page_size * page_start) + region->start;
    for (size_t i = page_start; i < page_start + ORDER(order); ++i)
        page_set(region, i);
    if (nfp_check)
        ((bmp_map_t *)region->page_alloc_si)->pointer_offset = next_free_page(region, page_start + ORDER(order));
    return phys_addr;
}
uintptr_t pages_reserve(mregion_t *region, unsigned int order, uint64_t offset)
{
    for (size_t i = offset; i < offset + ORDER(order); ++i)
    {
        page_set(region, i);
    }
    return (phys_page_size * offset) + region->start;
}