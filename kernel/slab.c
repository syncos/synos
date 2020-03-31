#include <slab.h>
#include <mm.h>

void * heap_start;
mheader_t * header_start;
mpointer_t * pointer_start;

int kslab_init()
{
    heap_start = kpages_alloc(0, PAGE_WRITABLE | PAGE_EXECUTE);
    if (!heap_start)
        return 0;
    
    header_start = heap_start;

    pointer_start = heap_start + sizeof(mheader_t);

    header_start->size      = page_size;
    header_start->size_max  = header_start->size - sizeof(mheader_t) - sizeof(mpointer_t);
    header_start->next      = NULL;

    pointer_start->size     = header_start->size_max;
    pointer_start->next     = NULL;

    return 1;
}

// Checks all pointers for the one with the greatest size
static inline unsigned long findSize_max(mheader_t *header)
{
    unsigned long max = 0;
    for (mpointer_t *p = (void*)((unsigned long)header + sizeof(mheader_t)); p != NULL; p = p->next)
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
void * kmalloc(unsigned long size, unsigned int flags)
{
    if (!size)
        return NULL;
    
    mheader_t *h;
    mheader_t *hl = NULL;
    mpointer_t *p;
    // Find a header that can allocate at least [size] bytes
    for (h = header_start; h != NULL; h = h->next) {
        if (h->size_max >= size)
            break;
        hl = h;
    }
    if (!h) {
        // No header found
        // Allocate a new header
        unsigned long pages = (size + sizeof(mheader_t) + sizeof(mpointer_t) + (page_size-1)) / page_size;
        unsigned int order = pages_to_order(pages);
        pages = ORDER(order);

        if (pages_free < pages)
            return NULL;
        hl->next = kpages_alloc(order, PAGE_WRITABLE | PAGE_EXECUTE);
        if (!hl->next)
            return NULL;
        h = hl->next;

        h->size = pages * page_size;
        h->size_max = h->size - sizeof(mheader_t) - sizeof(mpointer_t);
        h->next = NULL;
        p = (void*)((unsigned long)h + sizeof(mheader_t));

        p->size = h->size_max;
        p->next = NULL;
        goto pfind;
    }

    // Find a good pointer
    for (p = (void*)((unsigned long)h + sizeof(mheader_t)); p != NULL; p = p->next)
        if (p->size >= size)
            break;
    pfind:;

    void * address = (void*)((unsigned long)p + sizeof(mpointer_t));

    if (p->size - size > sizeof(mpointer_t)) {
        // The size of the selected segment is greater than the bytes requested and the remainder is large enough to at least fit another pointer and one byte
        mpointer_t *newp = (void*)((unsigned long)address + size);
        newp->next = p->next;
        newp->size = p->size - size - sizeof(mpointer_t);
        p->next = newp;
    }
    p->size = 0;
    h->size_max = findSize_max(h);

    return address;
}
void * kzmalloc(unsigned long size, unsigned int flags)
{
    void * p = kmalloc(size, flags);
    if (!p) return NULL;

    for (unsigned long i = 0; i < size; ++i)
        ((char*)p)[i] = 0;
    
    return p;
}

void kfree(void * address)
{
    if (!address)
        return;
    // First, find the heap where the address points to
    mheader_t *h;
    mpointer_t *p;
    for (h = header_start; h != NULL; h = h->next)
        if ((unsigned long)address > (unsigned long)h && (unsigned long)address < (unsigned long)h + h->size)
            break;
    if (!h)
        return;
    // We've found the header, now find the pointer
    for (p = (void*)((unsigned long)h + sizeof(mheader_t)); p != NULL; p = p->next)
        if ((unsigned long)p + sizeof(mpointer_t) == (unsigned long)address)
            break;
    if (!p)
        return;

    // Free
    if (p->next != NULL)
        p->size = (unsigned long)p->next - (unsigned long)address;
    else
        p->size = h->size - ((unsigned long)address - (unsigned long)h);

    pointers_merge((void*)((unsigned long)h + sizeof(mheader_t)));
    h->size_max = findSize_max(h);

    return;
}
unsigned long ksize(void * address)
{
    if (!address)
        return 0;
    // First, find the heap where the address points to
    mheader_t *h;
    mpointer_t *p;
    for (h = header_start; h != NULL; h = h->next)
        if ((unsigned long)address > (unsigned long)h && (unsigned long)address < (unsigned long)h + h->size)
            break;
    if (!h)
        return 0;
    // We've found the header, now find the pointer
    for (p = (void*)((unsigned long)h + sizeof(mheader_t)); p != NULL; p = p->next)
        if (p + sizeof(mpointer_t) == address)
            break;
    if (!p)
        return 0;

    return (unsigned long)p->next - (unsigned long)address;
}