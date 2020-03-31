#ifndef ARCH_MEMORY_H
#define ARCH_MEMORY_H
#include <proc.h>
#include <stdint.h>

#define MAX_ORDER 16

extern const uintptr_t page_size;
extern const uintptr_t page_align;

extern void             page_map        (void * vaddress, uintptr_t paddress, unsigned int flags, proc_t * proc);
extern void             page_unmap      (void * vaddress, proc_t * proc);
extern int              page_present    (void * vaddress, proc_t * proc);
extern uintptr_t        page_paddr      (void * vaddress, proc_t * proc);

extern void *           kpage_map       (void * vaddress, uintptr_t paddress, unsigned int flags);
extern void             kpage_unmap     (void * vaddress);
extern int              kpage_present   (void * vaddress);
extern uintptr_t        kpage_paddr     (void * vaddress);

#define PAGE_WRITABLE 1
#define PAGE_USER_ACCESS 2
#define PAGE_NO_CACHE 4
#define PAGE_EXECUTE 8

#endif