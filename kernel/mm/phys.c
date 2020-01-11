#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/memory.h>
#include <string.h>

mregion_t *regions;
mregion_t *alloc_region;

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

static void regions_map()
{
    for (mregion_t *reg = regions; reg != NULL; reg = reg->next)
    {
        if (reg == alloc_region)
            continue;
    }
}
#define TOTAL_PAGE_TABLE_SIZE (((System.memid.totalSize / phys_page_size) * bits_per_page) / 8)
int ppage_init()
{
    regions = findNextRegion(get_regions());
    alloc_region = regions;
    regup:
    if (alloc_region == NULL)
        panic("No available memory to allocate initial memory tables!");
    if (alloc_region->size < TOTAL_PAGE_TABLE_SIZE || alloc_region->start < LM_SIZE)
    {
        alloc_region = findNextRegion(alloc_region->next);
        goto regup;
    }

    size_t pages = alloc_region->size / phys_page_size;
    size_t page_tbl_size = ((pages * bits_per_page) + 7) / 8;
    void *regst = memstck_malloc(page_tbl_size);
    void *regsb = memstck_malloc(mm_sb_size);
    if (regst == NULL || regsb == NULL)
        panic("No heap to allocate memory to!");
    region_map(alloc_region, pages, regsb, regst);

    pages_reserve(alloc_region, 7, 5);

    return 0;
}