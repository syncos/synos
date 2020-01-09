#include <synos/mm.h>
#include "bmp.h"
#include <string.h>

const size_t mm_sb_size = sizeof(bmp_map_t);
const size_t bits_per_page = 1;

void region_map(mregion_t *region, size_t pages, void *sb, void *pageent)
{
    region->page_alloc_si = sb;

    bmp_map_t *bmap = (bmp_map_t *)sb;
    bmap->pages = pages;
    bmap->pointer_offset = 0;
    bmap->list_pages = pageent;
    
    size_t stsize = pages / 8;
    if (stsize % 8 != 0)
        ++stsize;
    
    memset(pageent, 0, stsize);
}

void outofmem(mregion_t *region)
{
    region->mem_full = true;
}