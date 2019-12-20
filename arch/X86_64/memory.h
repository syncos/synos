#ifndef X64_MEMORY_H
#define X64_MEMORY_H
#include <inttypes.h>

#define GDT_LEN (1 + 2 + 2 + 1) // Null entry + ring 0 code and data + ring 3 code and data + tss entry

#define GDT_NULL_SELECTOR 	   0x0000
#define GDT_KERN_CODE_SELECTOR 0x0008
#define GDT_KERN_DATA_SELECTOR 0x0010
#define GDT_PROG_CODE_SELECTOR 0x0018
#define GDT_PROG_DATA_SELECTOR 0x0020
#define GDT_TSS_SELECTOR       0x0028

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

void initGDT();
void initTSS();

#endif