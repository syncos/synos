#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/memory.h>
#include <spinlock.h>
#include <inttypes.h>
#include <stddef.h>
#include <string.h>

const size_t mm_sb_size = sizeof(bpa_map_t);
const size_t bits_per_page = BITS_PER_PAGE;

void *next_free_vpage;

mregion_t *regions;
mregion_t *next_region;
bool outOfMem;

static void *fnfp(void *nfp)
{
    for (void *addr = nfp; ; addr += virt_page_size)
    {
        if (!pga_ispresent(addr))
            return addr;
    }
}

int vpage_init()
{
    pga_init();
    pga_map(0, 0, 0, VPAGE_NOT_WRITABLE | VPAGE_NO_EXECUTE);

    next_free_vpage = fnfp((void*)0x100000);
    return 0;
}

void *vpage_map(uintptr_t paddress, unsigned int flags)
{
    pga_map(next_free_vpage, paddress, 0, flags);
    void *addr = next_free_vpage;
    next_free_vpage = fnfp(next_free_vpage);
    return addr;
}
void *vpages_map(uintptr_t paddress, unsigned int order, unsigned int flags)
{
    for (uintptr_t start = (uintptr_t)next_free_vpage; start < __UINTPTR_MAX__; start += virt_page_size) 
    {
        for (uintptr_t pgs = start; (pgs - start) / virt_page_size < (1UL << order); pgs += virt_page_size)
        {
            if (pga_ispresent((void*)pgs))
                goto nav;
        }
        pga_map((void*)start, paddress, order, flags);
        if (start == (uintptr_t)next_free_vpage)
            next_free_vpage = fnfp(next_free_vpage + BLOCK_ORDER_SIZE(order));
        return (void*)start;
        nav:
        continue;
    }
    return NULL;
}
void *vpage_smap(uintptr_t paddress, void *vaddress, unsigned int flags)
{
    pga_map(vaddress, paddress, 0, flags);
    return vaddress;
}
void *vpages_smap(uintptr_t paddress, void *vaddress, unsigned int order, unsigned int flags)
{
    pga_map(vaddress, paddress, order, flags);
    return vaddress;
}
void *vpages_reserve(void *vaddress, unsigned int order)
{
    pga_map(vaddress, 0, order, VPAGE_NOT_WRITABLE);
    return vaddress;
}

void vpage_unmap(void *vaddress)
{
    pga_unmap(vaddress, 0);
}
void vpages_unmap(void *vaddress, unsigned int order)
{
    pga_unmap(vaddress, order);
}

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
    if (r->mem_full) {
        start = start->next;
        goto search;
    }
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
    if (next_region->mem_full) {
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
        if (pages == 0) {
            map_reg->mem_full = true;
            continue;
        }
        size_t page_tbl_size = ((pages * bits_per_page) + 7) / 8;
        size_t pages_tbl_p = (page_tbl_size + (page_size - 1)) / page_size;
        size_t sb_p = (mm_sb_size + (page_size - 1)) / page_size;
        
        uintptr_t pa_sb = pages_alloc(alloc_region, log_order(sb_p));
        uintptr_t pa_tbl = pages_alloc(alloc_region, log_order(pages_tbl_p));

        void *regst = vpages_map(pa_tbl, log_order(pages_tbl_p), 0);
        void *regsb = vpages_map(pa_sb, log_order(sb_p), 0);

        region_map(map_reg, pages, regsb, regst);
        mem_p_protect(map_reg);
    }
    next_region = findFreeRegion(regions);

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

void block_split(mregion_t *region, unsigned int order);
void zblock_split(mregion_t *region, unsigned int order, size_t offset);
void block_merge(mregion_t *region, unsigned int order, size_t offset);
void out_of_mem(mregion_t *region);

static inline bool block_check(mregion_t *region, unsigned int order, size_t offset)
{
    bpa_map_t *map = region->page_alloc_si;
    return (((char*)map->free_area[order])[offset/8] >> (offset%8)) & 1U;
}
static inline void block_set(mregion_t *region, unsigned int order, size_t offset)
{
    bpa_map_t *map = region->page_alloc_si;
    ((char*)map->free_area[order])[offset/8] |= (1 << (offset%8));
}
static inline void block_clear(mregion_t *region, unsigned int order, size_t offset)
{
    bpa_map_t *map = region->page_alloc_si;
    ((char*)map->free_area[order])[offset/8] &= ~(1 << (offset%8));
}
static inline void blocks_set(mregion_t *region, unsigned int order, size_t offset_start, size_t length)
{
    for (size_t i = offset_start; i < offset_start + length; ++i)
        block_set(region, order, i);
}
static inline void blocks_clear(mregion_t *region, unsigned int order, size_t offset_start, size_t length)
{
    for (size_t i = offset_start; i < offset_start + length; ++i)
        block_clear(region, order, i);
}
static inline size_t free_area_length(size_t pages, unsigned int order)
{
    for (unsigned int i = 0; i < order; ++i)
        pages /= 2;
    return pages;
}
static inline unsigned int order_max(size_t pages)
{
    unsigned int order;
    for (order = 0; order < MAX_ORDER; ++order) 
    {
        if (pages % 2)
            return order;
        pages /= 2;
    }

    return MAX_ORDER - 1;
}
static inline size_t find_next_free_page(mregion_t *region, unsigned int order, size_t start)
{
    bpa_map_t *map = region->page_alloc_si;
    for (size_t i = start; i < free_area_length(map->pages, order); ++i)
    {
        if (!block_check(region, order, i))
            return i;
    }
    map->pages_free[order] = 0;
    return 0;
}

static void _free_area_map(mregion_t *region)
{
    size_t start_addr = region->start;
    bpa_map_t *map = region->page_alloc_si;
    size_t p = map->pages;

    ord:;
    unsigned int order = order_max(p);
    if (order != MAX_ORDER - 1)
    {
        if (free_area_length(map->pages, order+1) == 0) {
            map->pages_free[order] = free_area_length(p, order);
            blocks_clear(region, order, 0, map->pages_free[order]);
            return;
        }
        map->next_free_page[order] = free_area_length(p, order)-1;
        block_clear(region, order, map->next_free_page[order]);
        ++map->pages_free[order];
        p -= (1 << order);
        goto ord;
    }
    map->pages_free[order] = free_area_length(p, order);
    blocks_clear(region, order, 0, map->pages_free[order]);
}

void region_map(mregion_t *region, size_t pages, void *sb, void *pageent)
{
    spinlock_lock(&region->lock);
    region->page_alloc_si = sb;
    bpa_map_t *map = sb;
    map->pages = pages;
    map->free_area_size = ((pages * BITS_PER_PAGE) + 7) / 8;
    region->pages_total = pages;
    region->pages_free = pages;
    region->mem_full = false;

    memset(pageent, 0xFF, map->free_area_size);
    memset(map->pages_free, 0, sizeof(size_t)*MAX_ORDER);
    memset(map->next_free_page, 0, sizeof(size_t)*MAX_ORDER);
    map->free_area[0] = pageent;

    void *last_pos = pageent;
    size_t last_size = (pages + (8 - 1)) / 8;
    for (int i = 1; i < MAX_ORDER; ++i)
    {
        last_pos += last_size;
        map->free_area[i] = last_pos;
        last_size = (last_size + 1) / 2;
    }
    _free_area_map(region);
    spinlock_unlock(&region->lock);
}

void out_of_mem(mregion_t *region)
{
    region->mem_full = true;
}

void block_split(mregion_t *region, unsigned int order)
{
    if (order == 0 || order >= MAX_ORDER)
        return;
    bpa_map_t *map = region->page_alloc_si;
    ord_check:
    if (map->pages_free[order] > 0)
    {
        block_set(region, order, map->next_free_page[order]);
        block_clear(region, order-1, map->next_free_page[order]*2);
        block_clear(region, order-1, map->next_free_page[order]*2+1);

        if (map->next_free_page[order-1] > map->next_free_page[order]*2 || map->pages_free[order-1] == 0)
            map->next_free_page[order-1] = map->next_free_page[order]*2;
        map->pages_free[order-1] += 2;
        
        if (map->pages_free[order] != 1)
            map->next_free_page[order] = find_next_free_page(region, order, ++map->next_free_page[order]);
        else
            map->next_free_page[order] = 0;
        --map->pages_free[order];

        return;
    }
    if (order == MAX_ORDER - 1)
    {
        out_of_mem(region);
        return;
    }
    block_split(region, order+1);
    if (map->pages_free[order] == 0)
    {
        out_of_mem(region);
        return;
    }
    goto ord_check;
}
void zblock_split(mregion_t *region, unsigned int order, size_t offset)
{
    if (order == 0 || order >= MAX_ORDER)
        return;
    
    bpa_map_t *map = region->page_alloc_si;
    if (!block_check(region, order, offset))
    {
        pos:
        block_set(region, order, offset);
        block_clear(region, order-1, offset*2);
        block_clear(region, order-1, offset*2+1);

        if (map->next_free_page[order-1] > map->next_free_page[order]*2)
            map->next_free_page[order-1] = map->next_free_page[order]*2;
        map->pages_free[order-1] += 2;

        if (map->pages_free[order] == 1)
            map->next_free_page[order] = 0;
        else if (offset == map->next_free_page[order])
            map->next_free_page[order] = find_next_free_page(region, order, offset+1);
        --map->pages_free[order];

        return;
    }
    if (order == MAX_ORDER - 1)
        return;
    zblock_split(region, order+1, offset/2);
    if (!block_check(region, order, offset))
        goto pos;
    return;
}
void block_merge(mregion_t *region, unsigned int order, size_t offset)
{
    if (order >= MAX_ORDER - 1)
        return;
    
    bpa_map_t *map = region->page_alloc_si;
    offset &= ~(1UL);

    block_set(region, order, offset);
    block_set(region, order, offset + 1);
    block_clear(region, order+1, offset/2);

    map->pages_free[order] -= 2;
    ++map->pages_free[order+1];

    if (map->next_free_page[order] == offset || map->next_free_page[order] == offset + 1)
        map->next_free_page[order] = find_next_free_page(region, order, offset + 2);
    if (map->next_free_page[order+1] > offset/2 || map->pages_free[order+1] == 1)
        map->next_free_page[order+1] = offset/2;
    
    if ((offset/2) % 2 == 0) {
        if (!block_check(region, order+1, (offset/2) + 1))
            block_merge(region, order+1, offset/2);
    }
    else
        if (!block_check(region, order+1, (offset/2) - 1))
            block_merge(region, order+1, offset/2);
}

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

        if (region->pages_free <= (1UL << order))
            out_of_mem(region);
        region->pages_free -= (1UL << order);
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
        if (region->pages_free <= (1UL << order))
            out_of_mem(region);
        region->pages_free -= (1 << order);
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
    if (!block_check(region, order, offset)) {
        block_set(region, order, offset);
        --map->pages_free[order];
        if (map->next_free_page[order] == offset)
            map->next_free_page[order] = find_next_free_page(region, order, offset+1);
    }
    if (region->pages_free <= (1UL << order))
        out_of_mem(region);
    region->pages_free -= (1 << order);

    spinlock_unlock(&region->lock);
    return (BLOCK_ORDER_SIZE(order) * offset) + region->start;
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

    if (region->pages_free == 0)
        region->mem_full = true;
    region->pages_free += (1 << order);

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
void page_free(mregion_t *region, uintptr_t phaddr)
{
    pages_free(region, phaddr, 0);
}