#ifndef K_MM_H
#define K_MM_H
#include <synos/arch/memory.h>

#ifndef MAX_ORDER
#define MAX_ORDER 10
#endif
#ifndef MAX_ORDER_ENT
#define MAX_ORDER_ENT 10
#endif

#define MAX_ORDER_COUNT (1 << MAX_ORDER)
#define BLOCK_ORDER_SIZE(order) (phys_page_size * (1 << order))

struct block;
typedef struct page
{
    uintptr_t addr;
    void* start;
}page_t;
typedef struct block
{
    unsigned int order;
    bool present;

    bool use_blocks;
    struct block *child0;
    struct block *child1;

    page_t page_start;
    page_t page_end;
}block_t;

typedef struct
{
    block_t blocks[MAX_ORDER_ENT];
    
}free_area_t;

enum mem_regions_attributes
{
    MEM_REGION_READ         = (1 << 0),
    MEM_REGION_WRITE        = (1 << 1),
    MEM_REGION_PROTECTED    = (1 << 2),
    MEM_REGION_MAPPED       = (1 << 3),
    MEM_REGION_BAD          = (1 << 4),
    MEM_REGION_PRESERVE     = (1 << 5),
    MEM_REGION_AVAILABLE    = (1 << 6),
};
typedef struct mem_regions
{
    uintptr_t start;
    uintptr_t size;
    uint8_t attrib;

    uint64_t page_alloc_start;

    uint32_t chain_length;
    struct mem_regions *next;
}mregion_t;

extern struct arch_page_size PS;

int mm_init();
int ppage_init();

page_t getPhysPage(size_t index);

#define __GFP_DMA 1
#define __GFP_HIGHMEM 2
#define GFP_DMA __GFP_DMA

#define __GFP_WAIT   4
#define __GFP_HIGH   8
#define __GFP_IO     16
#define __GFP_HIGHIO 32
#define __GFP_FS     64

#define GFP_ATOMIC      __GFP_HIGH
#define GFP_NOIO        (__GFP_HIGH | __GFP_WAIT)
#define GFP_NOHIGHIO    (__GFP_HIGH | __GFP_WAIT | __GFP_IO)
#define GFP_NOFS        (__GFP_HIGH | __GFP_WAIT | __GFP_IO | __GFP_HIGHIO)
#define GFP_KERNEL      (__GFP_HIGH | __GFP_WAIT | __GFP_IO | __GFP_HIGHIO | __GFP_FS)
#define GFP_NFS         GFP_KERNEL
#define GFP_USER        (__GFP_WAIT | __GFP_IO | __GFP_HIGHIO | __GFP_FS)
#define GFP_HIGHUSER    (__GFP_WAIT | __GFP_IO | __GFP_HIGHIO | __GFP_FS | __GFP_HIGHMEM)
#define GFP_KSWAPD      GFP_USER

// Allocates a single physical page (does NOT map the page into virtual memory, only returns the physical address)
page_t alloc_page(unsigned int gfp_mask);
// Same as alloc_page, but allocates pow(2, order) pages and returns the block struct
block_t alloc_pages(unsigned int gfp_mask, unsigned int order);

// Allocate a single frame, zero it, and map it to virtual memory and return the virtual address
uintptr_t get_free_page(unsigned int gfp_mask);
// Same as get_free_page, but does not zero the page's value
uintptr_t __get_free_page(unsigned int gfp_mask);
// Allocate pow(2, order) pages and map them into virtual memory and return the virtual address
uintptr_t __get_free_pages(unsigned int gfp_mask, unsigned int order);

// Frees 
void free_page(const page_t *page);
void free_pages(unsigned int order, const page_t* pages);
#endif