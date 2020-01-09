#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/memory.h>
#include <string.h>

mregion_t *regions;

static mregion_t *findNextRegion(mregion_t *start)
{
    for (mregion_t *region = start; region != NULL; region = region->next)
    {
        if ((region->attrib & (MEM_REGION_AVAILABLE | MEM_REGION_READ | MEM_REGION_WRITE)) == (MEM_REGION_AVAILABLE | MEM_REGION_READ | MEM_REGION_WRITE)
            && (region->attrib & (MEM_REGION_BAD | MEM_REGION_PRESERVE | MEM_REGION_PROTECTED)) == 0
            && region->size >= phys_page_size)
        {
            return region;
        }
    }
    return NULL;
}

#define TOTAL_PAGE_TABLE_SIZE (((System.memid.totalSize / phys_page_size) * bits_per_page) / 8)
int ppage_init()
{
    regions = findNextRegion(get_regions());
    regup:
    if (regions == NULL)
        panic("No available memory to allocate initial memory tables!");
    if (regions->size < TOTAL_PAGE_TABLE_SIZE || regions->start < LM_SIZE)
    {
        regions = findNextRegion(regions->next);
        goto regup;
    }

    size_t pages = regions->size / phys_page_size;
    size_t page_tbl_size = (pages * bits_per_page) / 8;
    if (page_tbl_size % 8 != 0)
        ++page_tbl_size;
    void *regst = memstck_malloc(page_tbl_size);
    void *regsb = memstck_malloc(mm_sb_size);
    if (regst == NULL || regsb == NULL)
        panic("No heap to allocate memory to!");
    region_map(regions, pages, regsb, regst);

    uintptr_t addr = page_alloc(regions);
    pages_alloc(regions, 2);
    page_free(regions, addr);
    pages_alloc(regions, 3);

    return 0;
}