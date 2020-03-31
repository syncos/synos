#ifndef SLAB_H
#define SLAB_H
#include <arch/memory.h>

typedef struct __attribute__((__packed__)) mheader
{
    unsigned long size;
    unsigned long size_max;
    struct mheader * next;
}mheader_t;
typedef struct __attribute__((__packed__)) mpointer
{
    unsigned long size; // 0 = allocated
    struct mpointer * next;
}mpointer_t;

int kslab_init();

void * kmalloc(unsigned long size, unsigned int flags);
void * kzmalloc(unsigned long size, unsigned int flags);
#define kmalloc_array(n, size, flags) kmalloc(n*size, flags)
#define kcalloc(n, size, flags) kzmalloc(n*size, flags)

void kfree(void * address);
unsigned long ksize(void * address);

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

extern unsigned long kslab_alloc_size;
extern unsigned long kslab_mem_pool_size;

#endif