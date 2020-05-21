/*
    Synos memory page allocator
    Copyright (C) 2020 Jacob Paul

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
#include <mm.h>
#include <spinlock.h>
#include <string.h>

// pages_free and max_alloc_order can be used by the kernel to know how many pages of physical memory are left
// and how long the longest continuous fragment is (2^max_alloc_order pages)
unsigned long pages_free = 0;
m_region_t * pages_free_holder;
unsigned int max_alloc_order = 0;
m_region_t * max_alloc_order_holder;
unsigned long pages_total = 0;

// kvs functions use this variable to keep track of where the next free page(s) of memory is
void * kvs_next;

// block_* functions are used by the physical frame allocator to do bit manipulation on the region bitmaps
// See mm.h for info about regions
#define block_set(region, order, offset) ((char*)region->bmap.free_area[(order)])[(offset)/8] |= (1 << ((offset)%8))
#define block_clear(region, order, offset) ((char*)region->bmap.free_area[(order)])[(offset)/8] &= ~(1 << ((offset)%8))
#define block_check(region, order, offset) ((((char*)region->bmap.free_area[(order)])[(offset)/8] >> ((offset)%8)) & 1U)
static inline void blocks_set(m_region_t * region, unsigned int order, unsigned long offset, unsigned long length)
{
    for (unsigned long i = offset; i < offset + length; ++i)
        block_set(region, order, i);
}
static inline void blocks_clear(m_region_t * region, unsigned int order, unsigned long offset, unsigned long length)
{
    for (unsigned long i = offset; i < offset + length; ++i)
        block_clear(region, order, i);
}

// Helper functions to the mregion_* functions
static unsigned long _page_order_offset(unsigned long pages, unsigned int order_org, unsigned int order)
{
    if (order_org == order)
        return pages;
    if (order_org < order) {
        return (pages >> (order - order_org));
    }
    return (pages << (order_org - order));
}
static inline unsigned long _free_area_length(unsigned long pages, unsigned int order)
{
    for (unsigned int i = 0; i < order; ++i)
        pages /= 2;
    return pages;
}
static unsigned long _find_next_free_page(m_region_t * region, unsigned int order, unsigned long start)
{
    unsigned long fal = _free_area_length(region->pages_total, order);
    for (unsigned long i = start; i < fal; ++i)
        if (!block_check(region, order, i))
            return i;
    region->bmap.pages_free[order] = 0;
    return 0;
}
static unsigned int _find_max_alloc_order(m_region_t * region)
{
    for (unsigned int i = MAX_ORDER; i > 0; --i)
        if (region->bmap.pages_free[i])
            return i;
    return 0;
}
static unsigned int _order_max(unsigned long pages)
{
    unsigned int order;
    for (order = 0; order <= MAX_ORDER; ++order) 
    {
        if (pages % 2)
            return order;
        pages /= 2;
    }
    return MAX_ORDER;
}

static void block_split(m_region_t * region, unsigned int order)
{
    if (order == 0 || order > MAX_ORDER)
        return;
    if (region->bmap.pages_free[order] > 0) {
        ord_check:
        block_set(region, order, region->bmap.next_free_page[order]);
        block_clear(region, order-1, region->bmap.next_free_page[order]*2);
        block_clear(region, order-1, region->bmap.next_free_page[order]*2+1);

        if (region->bmap.next_free_page[order-1] > region->bmap.next_free_page[order]*2 || region->bmap.pages_free[order-1] == 0)
            region->bmap.next_free_page[order-1] = region->bmap.next_free_page[order]*2;
        region->bmap.pages_free[order-1] += 2;

        if (region->bmap.pages_free[order] != 1) {
            region->bmap.next_free_page[order] = _find_next_free_page(region, order, region->bmap.next_free_page[order]);
        }
        else {
            region->bmap.next_free_page[order] = 0;
            if (region->alloc_order_max == order) {
                region->alloc_order_max = _find_max_alloc_order(region);
                if (region->alloc_order_max > max_alloc_order || max_alloc_order_holder == region) {
                    max_alloc_order = region->alloc_order_max;
                    max_alloc_order_holder = region;
                }
            }
        }
        --region->bmap.pages_free[order];

        return;
    }
    if (order == MAX_ORDER - 1)
        return;
    block_split(region, order+1);
    if (region->bmap.pages_free[order] == 0)
        return;
    goto ord_check;
}
static void zblock_split(m_region_t * region, unsigned int order, unsigned long offset)
{
    if (order == 0 || order > MAX_ORDER)
        return;
    if (!block_check(region, order, offset)) {
        pos:
        block_set(region, order, offset);
        block_clear(region, order-1, offset*2);
        block_clear(region, order-1, offset*2+1);

        if (region->bmap.next_free_page[order-1] > region->bmap.next_free_page[order]*2 || region->bmap.pages_free[order-1] == 0)
            region->bmap.next_free_page[order-1] = region->bmap.next_free_page[order]*2;
        region->bmap.pages_free[order-1] += 2;

        if (region->bmap.pages_free[order] != 1) {
            region->bmap.next_free_page[order] = _find_next_free_page(region, order, region->bmap.next_free_page[order]);
            if (region->bmap.pages_free[order])
                --region->bmap.pages_free[order];
        }
        else {
            region->bmap.next_free_page[order] = 0;
            region->bmap.pages_free[order] = 0;
            if (region->alloc_order_max == order) {
                region->alloc_order_max = _find_max_alloc_order(region);
                if (region->alloc_order_max > max_alloc_order || max_alloc_order_holder == region) {
                    max_alloc_order = region->alloc_order_max;
                    max_alloc_order_holder = region;
                }
            }
        }

        return;
    }
    if (order == MAX_ORDER - 1)
        return;
    zblock_split(region, order+1, offset/2);
    if (!block_check(region, order, offset))
        goto pos;
    return;
}
static void block_merge(m_region_t * region, unsigned int order, unsigned long offset)
{
    if (order > MAX_ORDER)
        return;
    offset &= ~(1UL);

    block_set(region, order, offset);
    block_set(region, order, offset + 1);
    block_clear(region, order+1, offset/2);

    region->bmap.pages_free[order] -= 2;
    ++region->bmap.pages_free[order+1];

    if (region->bmap.next_free_page[order] == offset || region->bmap.next_free_page[order] == offset + 1)
        region->bmap.next_free_page[order] = _find_next_free_page(region, order, offset + 2);
    if (region->bmap.next_free_page[order+1] > offset/2 || region->bmap.pages_free[order+1] == 1)
        region->bmap.next_free_page[order] = offset/2;
    
    if ((offset/2) % 2 == 0) {
        if (!block_check(region, order+1, (offset/2) + 1))
            block_merge(region, order+1, offset/2);
    }
    else
        if (!block_check(region, order+1, (offset/2) - 1))
            block_merge(region, order+1, offset/2);
}

static inline void _free_area_map(m_region_t * region)
{
    unsigned long p = region->pages_total;

    ord:;
    unsigned int order = _order_max(p);
    if (order != MAX_ORDER) {
        if (_free_area_length(region->pages_total, order+1) == 0)
            goto done;
        unsigned long nfp = _free_area_length(p, order)-1;
        block_clear(region, order, nfp);
        if (nfp < region->bmap.next_free_page[order] || region->bmap.pages_free[order] == 0)
            region->bmap.next_free_page[order] = nfp;
        ++region->bmap.pages_free[order];
        p -= (ORDER(order));
        goto ord;
    }
    done:
    region->bmap.pages_free[order] = _free_area_length(p, order);
    region->alloc_order_max = order;
    if (region->alloc_order_max > max_alloc_order) {
        max_alloc_order = region->alloc_order_max;
        max_alloc_order_holder = region;
    }
    blocks_clear(region, order, 0, region->bmap.pages_free[order]);
}
int mregion_init(m_region_t * region, void * pageent)
{
    spinlock_lock(&region->lock);
    // mregion will only use regions with the flag M_REGION_USABLE toggled
    if (!(region->flags & M_REGION_USABLE))
        return 1;

    region->pages_free = region->pages_total;
    region->bmap.free_area_size = pageent_len(region->pages_total);
    // Set bmap variable to default values
    for (unsigned int i = 0; i <= MAX_ORDER; ++i) {
        region->bmap.pages_free[i] = 0;
        region->bmap.next_free_page[i] = 0;
    }
    memset(pageent, 0xFF, region->bmap.free_area_size);

    region->bmap.free_area[0] = pageent;
    void * current_pos = pageent + (region->pages_total + 7) / 8;
    unsigned long cpages = (region->pages_total + 1) / 2;
    for (unsigned int i = 1; i <= MAX_ORDER; ++i) {
        region->bmap.free_area[i] = current_pos;
        if (cpages == 1) {
            cpages = 0;
            ++current_pos;
        }
        current_pos += (cpages + 7) / 8;
        cpages = (cpages + 1) / 2;
    }
    _free_area_map(region);
    pages_free += region->pages_free;
    pages_total += region->pages_total;
    spinlock_unlock(&region->lock);
    return 1;
}
unsigned long mregion_alloc(m_region_t * region, unsigned int order)
{
    if (order > MAX_ORDER || region->alloc_order_max < order || region->pages_free == 0)
        return 0;
    spinlock_lock(&region->lock);

    check_ord:
    if (region->bmap.pages_free[order] > 0) {
        block_set(region, order, region->bmap.next_free_page[order]);
        unsigned long phys_addr = ((page_size * (ORDER(order))) * region->bmap.next_free_page[order]) + region->start;

        if (region->bmap.pages_free[order] != 1) {
            region->bmap.next_free_page[order] = _find_next_free_page(region, order, region->bmap.next_free_page[order]);
        }
        else {
            region->bmap.next_free_page[order] = 0;
            if (region->alloc_order_max == order) {
                region->alloc_order_max = _find_max_alloc_order(region);
                if (region->alloc_order_max > max_alloc_order || max_alloc_order_holder == region) {
                    max_alloc_order = region->alloc_order_max;
                    max_alloc_order_holder = region;
                }
            }
        }
        --region->bmap.pages_free[order];

        region->pages_free -= (ORDER(order));
        pages_free -= (ORDER(order));
        spinlock_unlock(&region->lock);
        return phys_addr;
    }
    if (order == MAX_ORDER) {
        spinlock_unlock(&region->lock);
        return 0;
    }
    block_split(region, order + 1);
    if (region->bmap.pages_free[order] == 0) {
        spinlock_unlock(&region->lock);
        return 0;
    }
    goto check_ord;
}
unsigned long mregion_reserve(m_region_t * region, unsigned long address, unsigned int order)
{
    if (order > MAX_ORDER)
        return 0;
    spinlock_lock(&region->lock);
    if (address < region->start || address >= region->start + region->size || region->pages_free == 0) {
        spinlock_unlock(&region->lock);
        return 0;
    }
    unsigned long page_start = _page_order_offset((address - region->start) / page_size, 0, order);
    if (page_start >= region->pages_total) {
        spinlock_unlock(&region->lock);
        return 0;
    }

    for (unsigned int corder = MAX_ORDER; corder > order; --corder) {
        unsigned p = _page_order_offset(page_start, order, corder);
        if (block_check(region, corder, p))
            continue;
        zblock_split(region, corder, p);
    }

    unsigned long phys_addr = ((page_size * (ORDER(order))) * page_start) + region->start;
    if (block_check(region, order, page_start)) {
        spinlock_unlock(&region->lock);
        return phys_addr;
    }
    block_set(region, order, page_start);
    if (region->bmap.pages_free[order] != 1) {
        region->bmap.next_free_page[order] = _find_next_free_page(region, order, region->bmap.next_free_page[order]);
        --region->bmap.pages_free[order];
    }
    else {
        region->bmap.next_free_page[order] = 0;
        region->bmap.pages_free[order] = 0;
        if (region->alloc_order_max == order) {
            region->alloc_order_max = _find_max_alloc_order(region);
            if (region->alloc_order_max > max_alloc_order || max_alloc_order_holder == region) {
                max_alloc_order = region->alloc_order_max;
                max_alloc_order_holder = region;
            }
        }
    }

    region->pages_free -= (ORDER(order));
    pages_free -= (ORDER(order));
    spinlock_unlock(&region->lock);
    return phys_addr;
}
void mregion_free(m_region_t * region, unsigned long address, unsigned int order)
{
    if (order > MAX_ORDER)
        return;
    spinlock_lock(&region->lock);
    if (address < region->start || address >= region->start + region->size)
        return;
    unsigned long offset = (address - region->start) / page_size;
    if (!block_check(region, order, offset))
        return;
    block_clear(region, order, offset);

    ++region->bmap.pages_free[order];
    region->pages_free += (ORDER(order));
    pages_free += (ORDER(order));

    unsigned long buddy = offset & ~(1UL);
    
    if (!block_check(region, order, buddy))
        block_merge(region, order, offset);
    spinlock_unlock(&region->lock);
}

void mregions_insert(m_region_t * region)
{   
    if (mregions == NULL || region->size >= mregions->size) {
        region->next = mregions;
        mregions = region;
        return;
    }
    m_region_t * cregion;
    for (cregion = mregions; cregion != NULL && cregion->next != NULL; cregion = cregion->next)
        if (region->size >= cregion->size && region->size <= cregion->next->size)
            break;
    region->next = cregion->next;
    cregion->next = region;
}
void mregions_remove(m_region_t * region)
{
    m_region_t * lregion = mregions;
    m_region_t * cregion = mregions;
    for (; cregion != NULL; ) {
        if (cregion == region) {
            if (cregion == lregion) {
                mregions = mregions->next;
                return;
            }
            lregion->next = cregion->next;
            return;
        }
        lregion = cregion;
        cregion = cregion->next;
    }
}
unsigned int pages_to_order(unsigned long pages)
{
    unsigned int order;
    for (order = 63; order > 0; --order)
        if (pages & (ORDER(order)))
            break;
    if (pages & ~(ORDER(order)))
        return order+1;
    return order;
}
unsigned long pageent_len(unsigned long pages)
{
    unsigned long bytes = 0;
    unsigned long p = pages;
    for (unsigned int i = 0; i <= MAX_ORDER; ++i) {
        bytes += (p + 7) / 8;
        if (p == 1)
            break;
        p = (p + 1) / 2;
    }
    return bytes+1;
}
unsigned long ppages_alloc(unsigned int order)
{
    if (max_alloc_order < order)
        return 0;
    for (m_region_t * c = mregions; mregions != NULL; c = c->next) {
        if (c->pages_free > 0 || c->alloc_order_max >= order) {
            unsigned long pd = mregion_alloc(c, order);
            if (pd != 0)
                return pd;
        }
    }
    return 0;
}
unsigned long ppages_reserve(unsigned long paddress, unsigned int order)
{
    for (unsigned long i = 0; i < ORDER(order); ++i) {
        for (m_region_t * c = mregions; c != NULL; c = c->next) {
            if (paddress + (page_size*i) >= c->start && paddress + (page_size*i) < c->start + (page_size * c->pages_total)) {
                mregion_reserve(c, paddress + (page_size*i), 0);
                goto cont;
            }
        }
        cont:
        continue;
    }
    return paddress;
}
void ppages_free(unsigned long address, unsigned int order)
{
    for (m_region_t * c = mregions; mregions != NULL; c = c->next) {
        if (address >= c->start && address < c->start + c->size)
            return mregion_free(c, address, order);
    } 
}

static void * kfnfp (void * nfp)
{
    for (void *addr = nfp; ; addr += page_size)
    {
        if (!kpage_present(addr))
            return addr;
    }
}

int kvs_init ()
{
    kvs_next = kfnfp((void*)0x1000);

    return 1;
}
void * kvs_map (unsigned long address, unsigned int order, unsigned int flags)
{
    for (unsigned long start = (unsigned long)kvs_next; start < ~(0UL); start += page_size) {
        for (unsigned long pgs = start + page_size; (pgs - start) / page_size < (ORDER(order)); pgs += page_size)
            if (kpage_present((void*)pgs))
                goto cont;
        for (unsigned long i = 0; i < (ORDER(order)); ++i)
            kpage_map((void*)(start + (page_size*i)), address + (page_size*i), flags);
        if (start == (unsigned long)kvs_next)
            kvs_next = kfnfp(kvs_next + (page_size * (ORDER(order))));
        return (void*)start;
        cont:
        continue;
    }
    return NULL;
}
void kvs_unmap(void * vaddress, unsigned int order)
{
    for (unsigned long i = 0; i < (ORDER(order)); ++i)
        kpage_unmap(vaddress + (page_size * i));
    if (kvs_next > vaddress)
        kvs_next = vaddress;
}

void * kpages_alloc(unsigned int order, unsigned int flags)
{
    if (max_alloc_order >= order) {
        unsigned long pd = ppages_alloc(order);
        if (pd == 0) return NULL;
        void * vd = kvs_map(pd, order, flags);
        if (!vd) {
            ppages_free(pd, order);
            return NULL;
        }
        return vd;
    }
    if (pages_free < (ORDER(order))) return NULL;

    void * vd = kvs_map(0, order, flags);
    if (!vd) return NULL;
    void * cpos = vd;
    unsigned long pages_total = (ORDER(order));
    while (pages_total > 0) {
        unsigned int corder = pages_to_order(pages_total);
        if ((ORDER(corder)) > pages_total)
            --corder;
        if (corder > max_alloc_order)
            corder = max_alloc_order;
        
        unsigned long pd = ppages_alloc(corder);
        for (unsigned int i = 0; i < (ORDER(corder)); ++i)
            kpage_map(cpos + (page_size * i), pd + (page_size * i), flags);
        cpos += page_size * (ORDER(corder));
        pages_total -= (ORDER(corder));
    }
    return vd;
}
int kpages_free(void * vaddress, unsigned int order)
{
    unsigned int i;
    unsigned long cpd = kpage_paddr(vaddress);
    unsigned long cpc = 1;
    if (!cpd) return 0;
    for (i = 1; i < (ORDER(order)); ++i) {
        if (kpage_paddr((void*)(vaddress + (page_size*i))) != cpd + (page_size*cpc)) {
            ppages_free(cpd, pages_to_order(cpc));
            cpd = kpage_paddr(vaddress + (page_size*i));
            cpc = 0;
            continue;
        }
        
        ++cpc;
    }
    if (cpc)
        ppages_free(cpd, pages_to_order(cpc));
    
    kvs_unmap(vaddress, order);

    return 1;
}