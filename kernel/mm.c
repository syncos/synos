#include <synos/synos.h>
#include <synos/mm.h>
#include <string.h>

void *heap_start;
mheader_t *header_start;
mpointer_t *pointer_start;

bool MemStack_init = false;
bool MemStack_enable = true;
uintptr_t MemStack;

int mm_init()
{
    vpage_init();
    ppage_init();

    // Allocate first page for the heap
    heap_start      = __get_free_page(GFP_KERNEL);
    // The header is at the start of the page
    header_start    = heap_start;
    // First pointer shortly thereafter
    pointer_start   = heap_start + sizeof(mheader_t);

    if (!heap_start)
        panic("No more memory to allocate the kernel heap to!");

    // Set the header values
    header_start->size     = virt_page_size;
    header_start->size_max = header_start->size;
    header_start->next     = NULL; // Currently only page(s)

    // Start with a pointer to all space left of the frame
    pointer_start->size    = header_start->size;
    pointer_start->next    = NULL;

    System.MMU_enabled = true;
    memstck_disable();

    return 0;
}

// Checks all pointers for the one with the greatest size
static inline size_t findSize_max(mheader_t *header)
{
    size_t max = 0;
    for (mpointer_t *p = (void*)((uintptr_t)header + sizeof(mheader_t)); p != NULL; p = p->next)
        if (p->size > max)
            max = p->size;
    return max;
}
// Find pointers that aren't allocated neighboring eachother and merge them
static inline void pointers_merge(mpointer_t *pointer_s)
{
    for (mpointer_t *p = pointer_s; p->next != NULL;)
    {
        if (p->size > 0 && p->next->size > 0) {
            p->size += p->next->size;
            p->next = p->next->next;
        }
        else {
            p = p->next;
        }
    }
}

void* kmalloc(size_t bytes)
{
    if (!bytes)
        return NULL;
    if (!System.MMU_enabled)
    {
        // MM has not been initalized (yet), instead use the hacky memstck_malloc (primarily used by the arch_init function)
        return memstck_malloc(bytes);
    }

    mheader_t *h;
    mheader_t *hl = NULL;
    mpointer_t *p;
    // Find a header that can allocate at least [bytes] bytes
    for (h = header_start; h != NULL; h = h->next)
    {
        if (h->size_max >= bytes)
            break;
        hl = h;
    }
    if (!h) {
        // No header found
        // Allocate a new header
        size_t pages = (bytes + sizeof(mheader_t) + sizeof(mpointer_t) + (virt_page_size-1)) / virt_page_size;
        unsigned int order = log_order(pages);
        pages = ORDER(order);

        hl->next = __get_free_pages(GFP_KERNEL, order);
        if (!hl->next)
            return NULL;
        h = hl->next;

        // Set values
        h->size = pages * virt_page_size;
        h->size_max = h->size;
        h->next = NULL;
        p = (void*)((size_t)h + sizeof(mheader_t));

        p->size = h->size;
        p->next = NULL;
    }

    // Find a good pointer
    for (p = (void*)((size_t)h + sizeof(mheader_t)); p != NULL; p = p->next)
        if (p->size >= bytes)
            break;
    
    // The pointer we will use is now in p
    void *address = p + sizeof(mpointer_t);

    if (p->size - bytes > sizeof(mpointer_t)) {
        // The size of the selected segment is greater than the bytes requested and the remainder is large enough to fit another pointer and one byte
        mpointer_t *newp = address + bytes;
        newp->next = p->next;
        newp->size = p->size - bytes - sizeof(mpointer_t);
        p->next = newp;
    }
    p->size = 0; // Set to 0, this way we can identify which pointers are allocated and which aren't
    h->size_max = findSize_max(h);

    return address;
}    
void kfree(void* address)
{
    if (!System.MMU_enabled)
        return;

    // First, find the heap where the address points to
    mheader_t *h;
    mpointer_t *p;
    for (h = header_start; h != NULL; h = h->next)
        if ((uintptr_t)address > (uintptr_t)h && (uintptr_t)address < (uintptr_t)h + h->size)
            break;
    if (!h)
        return;
    // We've found the header, now find the pointer
    for (p = (void*)((uintptr_t)h + sizeof(mheader_t)); p != NULL; p = p->next)
        if (p + sizeof(mpointer_t) == address)
            break;
    if (!p)
        return;
    
    // Free
    p->size = (uintptr_t)p->next - (uintptr_t)address;
    // Wipe the memory
    memset(address, 0, p->size);

    // Merge pointers
    pointers_merge((void*)((uintptr_t)h + sizeof(mheader_t)));
    h->size_max = findSize_max(h);

    return;
}

void* memstck_malloc(size_t bytes)
{
    if (!MemStack_enable)
        return NULL;
    if (!MemStack_init)
    {
        MemStack = _MemEnd + 64; // Padding just in case
        MemStack_init = true;
    }
    if (MemStack >= 0x200000)
    {
        MemStack_enable = false;
        return NULL;
    }
    if (MemStack + bytes >= 0x200000)
        return NULL;
    void* pointer = (void*)MemStack;

    MemStack += bytes + 1;
    ((char*)pointer)[bytes] = 0;

    return pointer;
}

void memstck_disable()
{
    MemStack_enable = false;
}

void *__get_free_page(unsigned int gfp_mask)
{
    uintptr_t page_address = alloc_page(gfp_mask);
    if (!page_address)
        return NULL;
    return vpage_map(page_address, 0);
}
void *__get_free_pages(unsigned int gfp_mask, unsigned int order)
{
    uintptr_t pages_address = alloc_pages(gfp_mask, order);
    if (!pages_address)
        return NULL;
    return vpages_map(pages_address, order, 0);
}
void *get_free_page(unsigned int gfp_mask)
{
    void *mem = __get_free_page(gfp_mask);
    memset(mem, 0, virt_page_size);
    return mem;
}
void return_free_page(void *address)
{
    free_page(pga_getPhysAddr(address));
    vpage_unmap(address);
}
void return_free_pages(void *address, unsigned int order)
{
    free_pages(order, pga_getPhysAddr(address));
    vpages_unmap(address, order);
}