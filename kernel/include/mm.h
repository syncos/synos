#ifndef MM_H
#define MM_H
#include <arch/memory.h>
#include <stddef.h>

#define BITS_PER_PAGE 2

#define ORDER(order) (1UL << order)

extern const unsigned long KERNEL_END;

/* 
    The physical page allocator in the synos kernel splits all the physical memory into "memory regions".
    These regions are mostly based on memory maps provided by for example a bootloader.
    Because of this, physical page allocation happens on a regional level. Wrapper functions have been written that can select between different regions.

    IF YOU DO NOT HAVE TIME TO THINK ABOUT REGIONS AND JUST WANT TO ALLOCATE PHYSICAL PAGES, USE THE ppages_* FUNCTIONS

    In X86_64, c_entry sets up a fixed memory region of 2 MB starting at 0x100000, later it creates more regions based on memory information given by multiboot(2).
*/

/*
    The kernel can only request pages in powers of two ("order").
    order = 0 - pages = 1
    order = 1 - pages = 2
    order = 2 - pages = 4
    etc
*/

struct bmap
{
    unsigned long free_area_size;
    void * free_area[MAX_ORDER+1];
    unsigned long pages_free[MAX_ORDER+1];
    unsigned long next_free_page[MAX_ORDER+1];
};
typedef struct bmap bmap_t;

struct m_region
{
    unsigned long start;
    unsigned long size;
    unsigned int  flags;

    unsigned long pages_total;
    unsigned long pages_free;
    unsigned int  alloc_order_max;

    bmap_t bmap;

    struct m_region * next;

    int lock;
};
typedef struct m_region m_region_t;
#define M_REGION_READ 1
#define M_REGION_WRITE 2
#define M_REGION_RESERVED 4
#define M_REGION_MMAPPED 8
#define M_REGION_BAD 16
#define M_REGION_PROTECTED 32
#define M_REGION_USABLE 64

extern m_region_t * p_mem_regions;
extern unsigned long p_mem_regions_length;
extern unsigned long p_mem_totalsize;

// Returns an base 2 exponent that is greater or equal to pages
// 2 ^ return value >= pages
unsigned int pages_to_order(unsigned long pages);

unsigned long pageent_len(unsigned long pages);

// mregions is a linked list containing usable memory regions. The list is terminated with a nullptr
extern m_region_t * mregions;
// When inserting or removning regions, only use these functions!
void mregions_insert(m_region_t * region);
void mregions_remove(m_region_t * region);

// Synos ppage allocation works similarly to linux ppage allocator <https://www.kernel.org/doc/gorman/html/understand/understand009.html>
// Initalize a memory region for allocation
// start, size, flags, pages_total should be set beforehand
// pageent is used as bitmaps for the page allocator.
int mregion_init(m_region_t * region, void * pageent);
// Allocate 2^order pages from specified memory region. Returns 0 on error.
unsigned long mregion_alloc(m_region_t * region, unsigned int order);
// Allocate specific pages from specified memory region. address is absolute
unsigned long mregion_reserve(m_region_t * region, unsigned long address, unsigned int order);
// Free pages previously allocated with either mregion_alloc mregion_reserve. address is the physical address returned by any of the function.
void mregion_free(m_region_t * region, unsigned long address, unsigned int order);

// Allocated 2^order pages from any region. Returns 0 on error
unsigned long ppages_alloc(unsigned int order);
unsigned long ppages_reserve(unsigned long paddress, unsigned int order);
// Free pages previously allocated with ppages_alloc
void ppages_free(unsigned long address, unsigned int order);

// Initialize the kernel virtual address space
int    kvs_init();
// Map physical address into the kvs. Returns nullptr on error
void * kvs_map(unsigned long address, unsigned int order, unsigned int flags);
// Unmap virtual address in kvs previously mapped with kvs_map
void   kvs_unmap(void * vaddress, unsigned int order);

// RECOMMENDATION: consider to only use kpages_* function when in need of pages, instead of allocating ppages and mapping them manually
// since kpages support fragmentation of physical pages. I.E. kpages will be able to use all ppages currently available even if they are fragmented.

// Allocate 2^order physical pages, then map them into kvs
void * kpages_alloc(unsigned int order, unsigned int flags);
// Free pages previously allocated with kpages_alloc
int    kpages_free(void * vaddress, unsigned int order);

extern unsigned long pages_free;
extern unsigned long pages_total;
extern unsigned int max_alloc_order;

#endif