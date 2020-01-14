#ifndef K_MM_H
#define K_MM_H
#include <synos/arch/memory.h>

#ifndef MAX_ORDER
#define MAX_ORDER 10
#endif
#ifndef MAX_ORDER_ENT
#define MAX_ORDER_ENT 10
#endif

#define LM_SIZE 0x100000

extern volatile uintptr_t __BOOT_HEADER_START[];
extern volatile uintptr_t __BOOT_HEADER_END[];

extern volatile uintptr_t __KERN_MEM_START[];
extern volatile uintptr_t __KERN_MEM_END[];
extern volatile uintptr_t __KERN_MEM_SIZE[];

extern volatile uintptr_t __KERN_CODE_START[];
extern volatile uintptr_t __KERN_CODE_END[];
extern volatile uintptr_t __KERN_CODE_SIZE[];

extern volatile uintptr_t __KERN_DATA_START[];
extern volatile uintptr_t __KERN_DATA_END[];
extern volatile uintptr_t __KERN_DATA_SIZE[];

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

    bool mem_full;
    void *page_alloc_si;

    uint32_t chain_length;
    struct mem_regions *next;
    int lock;
}mregion_t;

extern struct arch_page_size PS;

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

int mm_init();
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

extern void  memstck_disable();
extern void* memstck_malloc(size_t bytes);

// Physical page allocator definition
extern const size_t mm_sb_size;
extern const size_t bits_per_page;

int ppage_init();

extern void region_map(mregion_t *region, size_t pages, void *sb, void *pageent);

extern uintptr_t page_alloc(mregion_t *region);
extern uintptr_t pages_alloc(mregion_t *region, unsigned int order);
extern uintptr_t pages_reserve(mregion_t *region, unsigned int order, uint64_t offset);

extern void page_free(mregion_t *region, uintptr_t phaddr);
extern void pages_free(mregion_t *region, uintptr_t phaddr, unsigned int order);

// Virtual page allocator definition
int vpage_init(); 

#define VPAGE_NOT_PRESENT 1
#define VPAGE_NOT_WRITABLE 2
#define VPAGE_USER_ACCESS 4
#define VPAGE_NO_CACHE 8
#define VPAGE_NO_EXECUTE 16

extern void *vpage_map(uintptr_t paddress, unsigned int flags);
extern void *vpages_map(uintptr_t paddress, unsigned int order, unsigned int flags);
extern void *vpage_smap(uintptr_t paddress, void *vaddress, unsigned int flags);
extern void *vpages_smap(uintptr_t paddress, void *vaddress, unsigned int order, unsigned int flags);
extern void *vpages_reserve(void *vaddress, unsigned int order);

extern uintptr_t vpage_unmap(void *vaddress);
extern uintptr_t vpages_unmap(void *vaddress, unsigned int order);

#endif