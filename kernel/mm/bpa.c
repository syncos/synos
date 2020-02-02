#include <synos/mm.h>
#include <spinlock.h>
#include <string.h>
#include <inttypes.h>
#include <stddef.h>

#define MAX_ORDER 10
#define BITS_PER_PAGE 2

#define ORDER(ord) (1 << ord)
#define MAX_ORDER_COUNT (1 << MAX_ORDER)
#define BLOCK_ORDER_SIZE(order) (page_size * (1 << order))

typedef struct bpa_map
{
    size_t pages;
    size_t free_area_size;
    void *free_area[MAX_ORDER];
    size_t pages_free[MAX_ORDER];
    size_t next_free_page[MAX_ORDER];
}bpa_map_t;

const size_t mm_sb_size = sizeof(bpa_map_t);
const size_t bits_per_page = BITS_PER_PAGE;

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
    if (!block_check(region, order, offset))
        --region->pages_free;
    ((char*)map->free_area[order])[offset/8] |= (1 << (offset%8));
}
static inline void block_clear(mregion_t *region, unsigned int order, size_t offset)
{
    bpa_map_t *map = region->page_alloc_si;
    if (block_check(region, order, offset))
        ++region->pages_free;
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

        if (map->pages_free[order] != 1)
            map->next_free_page[order] = find_next_free_page(region, order, ++map->next_free_page[order]);
        else
            map->next_free_page[order] = 0;
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
    block_set(region, order, offset);
    --map->pages_free[order];
    if (map->next_free_page[order] == offset)
        map->next_free_page[order] = find_next_free_page(region, order, offset+1);

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