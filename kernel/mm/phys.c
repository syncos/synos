#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/memory.h>
#include <string.h>

mregion_t *regions;
mregion_t *next_region;
bool outOfMem;

static mregion_t *findNextRegion(mregion_t *start)
{
    for (mregion_t *region = start; region != NULL; region = region->next)
    {
        if ((region->attrib & (MEM_REGION_AVAILABLE | MEM_REGION_READ | MEM_REGION_WRITE)) == (MEM_REGION_AVAILABLE | MEM_REGION_READ | MEM_REGION_WRITE)
            && (region->attrib & (MEM_REGION_BAD | MEM_REGION_PRESERVE | MEM_REGION_PROTECTED)) == 0
            && region->size >= page_size)
        {
            return region;
        }
    }
    return NULL;
}
static mregion_t *findFreeRegion(mregion_t *start)
{
    search:;
    mregion_t *r = findNextRegion(start);
    if (r == NULL) {
        outOfMem = true;
        return r;
    }
    if (r->mem_full)
        goto search;
    return r;
}
static mregion_t *findRegion(uintptr_t paddress, mregion_t *start)
{
    for (mregion_t *region = start; region != NULL; region = region->next)
    {
        if (region->start <= paddress && (region->start + region->size) > paddress)
            return region;
    }
    return NULL;
}

uintptr_t alloc_page(unsigned int gfp_mask)
{
    start:
    if (outOfMem)
        return 0;
    if (next_region->pages_free == 0) {
        next_region = findFreeRegion(next_region->next);
        goto start;
    }
        
    return page_alloc(next_region);
}
uintptr_t alloc_pages(unsigned int gfp_mask, unsigned int order)
{
    mregion_t *areg = next_region;
    if (outOfMem)
        return 0;
    start:
    if (outOfMem) {
        outOfMem = false;
        return 0;
    }
    uint64_t paddr = pages_alloc(areg, order);
    if (!paddr) {
        areg = findFreeRegion(areg->next);
        goto start;
    }
    return paddr;
}

void free_page(uintptr_t page)
{
    mregion_t *reg = findRegion(page, regions);
    if (!reg)
        return;
    page_free(reg, page);
    if (reg->start < next_region->start)
        next_region = reg;
    if (outOfMem)
        outOfMem = false;
}
void free_pages(unsigned int order, uintptr_t pages)
{
    mregion_t *reg = findRegion(pages, regions);
    if (!reg)
        return;
    pages_free(reg, pages, order);
    if (reg->start < next_region->start)
        next_region = reg;
    if (outOfMem)
        outOfMem = false;
}
#define TOTAL_PAGE_TABLE_SIZE (((System.memid.totalSize / page_size) * bits_per_page) / 8)
int ppage_init()
{
    outOfMem = false;
    regions = get_regions();
    mregion_t *alloc_region = findNextRegion(regions);
    regup:
    if (alloc_region == NULL)
        panic("No available memory to allocate initial memory tables!");
    if (alloc_region->size < TOTAL_PAGE_TABLE_SIZE || alloc_region->start < LM_SIZE)
    {
        alloc_region = findNextRegion(alloc_region->next);
        goto regup;
    }

    size_t pages = alloc_region->size / page_size;
    size_t page_tbl_size = ((pages * bits_per_page) + 7) / 8;
    void *regst = kmalloc(page_tbl_size);
    void *regsb = kmalloc(mm_sb_size);
    if (regst == NULL || regsb == NULL)
        panic("No heap to allocate memory to!");
    region_map(alloc_region, pages, regsb, regst);
    mem_p_protect(alloc_region);
    next_region = alloc_region;

    for (mregion_t *map_reg = regions; map_reg != NULL; map_reg = map_reg->next)
    {
        if (map_reg == alloc_region)
            continue;
        size_t pages = map_reg->size / page_size;
        if (pages == 0)
            continue;
        size_t page_tbl_size = ((pages * bits_per_page) + 7) / 8;
        size_t pages_tbl_p = (page_tbl_size + (page_size - 1)) / page_size;
        size_t sb_p = (mm_sb_size + (page_size - 1)) / page_size;
        
        uintptr_t pa_sb = pages_alloc(alloc_region, log_order(sb_p));
        uintptr_t pa_tbl = pages_alloc(alloc_region, log_order(pages_tbl_p));

        void *regst = vpages_map(pa_tbl, log_order(pages_tbl_p), 0);
        void *regsb = vpages_map(pa_sb, log_order(sb_p), 0);

        region_map(map_reg, pages, regsb, regst);
        mem_p_protect(map_reg);
        if (next_region->start > map_reg->start)
            next_region = map_reg;
    }
    next_region = findFreeRegion(next_region);

    return 0;
}

unsigned int log_order(size_t pages)
{
    unsigned int order = MAX_ORDER + 1;
    for (unsigned int i = (sizeof(size_t)*8)-1; ; --i)
    {
        if ((pages >> i) & 1U && order != MAX_ORDER + 1)
        {
            ++order;
            break;
        }
        if ((pages >> i) & 1U)
            order = i;
        if (i == 0)
            break;
    }
    if (order == MAX_ORDER + 1)
        return 0;
    return order;
}