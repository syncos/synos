#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/memory.h>
#include <string.h>

block_t free_area[MAX_ORDER][MAX_ORDER_ENT];
#define max_order_blocks free_area[MAX_ORDER-1]

mregion_t *current_region = NULL;

static unsigned int region_max_order(mregion_t region)
{
    uintptr_t region_pages = region.size / phys_page_size;
    for (unsigned int order = 1; ; ++order)
    {
        if (((uintptr_t)(1 << order)) > region_pages)
            return --order;
    }
    return 1;
}
static unsigned int order_entries(unsigned int order)
{
    unsigned int count = 0;
    for (unsigned int i = 0; i < MAX_ORDER_ENT; ++i)
    {
        if (free_area[order][i].present)
            ++count;
    }
    return count;
}
static void free_area_insert(unsigned int order, block_t block)
{
    for (unsigned int i = 0; i < MAX_ORDER_ENT; ++i)
    {
        if (!free_area[order][i].present)
        {
            free_area[order][i] = block;
            return;
        }
    }
}
static int findNextRegion()
{
    for (mregion_t *reg = current_region->next; reg->next != NULL; reg = reg->next)
    {
        if ((reg->attrib & (MEM_REGION_AVAILABLE | MEM_REGION_READ | MEM_REGION_WRITE)) == (MEM_REGION_AVAILABLE | MEM_REGION_READ | MEM_REGION_WRITE)
            && (reg->attrib & (MEM_REGION_BAD | MEM_REGION_PRESERVE | MEM_REGION_PROTECTED)) == 0
            && reg->size >= phys_page_size)
        {
            current_region = reg;
            return 0;
        }
    }
    // TODO: fix a handler when we're out of physical memory regions
    return 1;
}

#define good_reg(reg) ((reg->attrib & MEM_REGION_READ) && (reg->attrib & MEM_REGION_WRITE) && (reg->attrib & MEM_REGION_AVAILABLE) && !(reg->attrib & MEM_REGION_BAD))
static void _getMOB(mregion_t *region, block_t *block)
{
    block->order = MAX_ORDER;

    if (region->page_alloc_start + (phys_page_size * MAX_ORDER_COUNT) >= region->size || !good_reg(region))
    {
        block->present = false;
        return;
    }

    block->present = true;

    block->page_start.addr = (region->start + region->page_alloc_start) & ~(phys_page_size - 1);
    block->page_end.addr = (region->start + region->page_alloc_start + (phys_page_size * MAX_ORDER_COUNT)) & ~(phys_page_size - 1);

    block->page_start.start = (void*)block->page_start.addr;
    block->page_end.start = (void*)block->page_end.addr;

    region->page_alloc_start += (phys_page_size * MAX_ORDER_COUNT);
}
static void getMOB()
{
    for (unsigned int i = 0; i < MAX_ORDER_ENT; ++i)
    {
        if (max_order_blocks[i].present)
            continue;
        _gm:
        _getMOB(current_region, &max_order_blocks[i]);
        if (!max_order_blocks[i].present)
        {
            if (findNextRegion() != 0) // No more regions to allocate (once the current pool of physical memory is empty we're out)
                return;
            goto _gm;
        }
    }
}

int ppage_init()
{
    current_region = get_regions();

    memset(&max_order_blocks, 0, sizeof(max_order_blocks));
    for (int i = MAX_ORDER - 1; i >= 0; --i)
    {
        for (int t = 0; t < MAX_ORDER_ENT; ++t)
        {
            free_area[i][t].order = i;
            free_area[i][t].present = false;
            free_area[i][t].use_blocks = false;
        }
    }

    getMOB();

    return 0;
}

page_t getPhysPage(size_t index)
{
    page_t pgs;
    pgs.addr = phys_page_size * index;
    pgs.start = (void*)pgs.addr;
    return pgs;
}


static void block_split(unsigned int order)
{
    if (order <= 0)
        return;
    
    block_t nb0;
    block_t nb1;

    
}

page_t alloc_page(unsigned int gfp_mask)
{

}