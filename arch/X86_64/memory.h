#ifndef X64_MEMORY_H
#define X64_MEMORY_H
#include <inttypes.h>
#include <stddef.h>
#include "multiboot2.h"

#define GDT_LEN (1 + 2 + 2 + 1) // Null entry + ring 0 code and data + ring 3 code and data + tss entry

#define GDT_NULL_SELECTOR 	   0x0000
#define GDT_KERN_CODE_SELECTOR 0x0008
#define GDT_KERN_DATA_SELECTOR 0x0010
#define GDT_PROG_CODE_SELECTOR 0x0018
#define GDT_PROG_DATA_SELECTOR 0x0020
#define GDT_TSS_SELECTOR       0x0028

#define PAGE_PRESENT       1
#define PAGE_WRITABLE      2
#define PAGE_USER          4
#define PAGE_CACHE_WRITE   8
#define PAGE_CACHE_DISABLE 16
#define PAGE_ACCESSED      (1 << 5)
#define PAGE_DIRTY         (1 << 6)
#define PAGE_HUGE          (1 << 7)
#define PAGE_GLOBAL        (1 << 8)
#define PAGE_NO_EXECUTE    ((uint64_t)1 << 63)

struct GDT_entry
{
    uint16_t limit_low;

    uint16_t base_low;
	uint8_t  base_middle;

	uint8_t access;
	uint8_t granularity;

	uint8_t base_high;
}__attribute__((packed));
struct GDT_Pointer
{
    uint16_t size;
    uintptr_t base;
}__attribute__((packed));

struct TSS
{
    uint32_t resv0;

    uint64_t rsp0;
    uint64_t rsp1;
    uint64_t rsp2;

    uint32_t resv1;
    uint32_t resv2;

    uint64_t ist1;
    uint64_t ist2;
    uint64_t ist3;
    uint64_t ist4;
    uint64_t ist5;
    uint64_t ist6;
    uint64_t ist7;

    uint32_t resv3;
    uint32_t resv4;

    uint16_t IOPB_offset;

    uint16_t resv5;
}__attribute__((packed));

extern struct GDT_entry* gdt; // The "WIP" gdt (not the actual one thats loaded)
extern struct TSS *proc_tss;

extern uint64_t* PML_4;

void initGDT();
void initTSS();

#ifdef MEMSTACK_ENABLE
extern void* memstck_malloc(size_t bytes);
extern void* memstck_realloc(void* p, size_t bytes);
#endif

#endif