#ifndef X64_MEMORY_H
#define X64_MEMORY_H
#include <inttypes.h>

#define GDT_LEN 1 + 2 + 2 + 1 // Null entry + ring 0 code and data + ring 3 code and data + tss entry

struct GDT_entry
{
    uint16_t limit_low : 16;
    uint32_t base_low : 24;

    unsigned int accessed : 1;
	unsigned int read_write : 1; //readable for code, writable for data
	unsigned int conforming_expand_down : 1; //conforming for code, expand down for data
	unsigned int code : 1; //1 for code, 0 for data
	unsigned int always_1 : 1; //should be 1 for everything but TSS and LDT
	unsigned int DPL : 2; //priviledge level
	unsigned int present : 1;

	unsigned int limit_high :4;
	unsigned int available :1;
	unsigned int always_0 :1; //should always be 0
	unsigned int big :1; //32bit opcodes for code, uint32_t stack for data
	unsigned int gran :1; //1 to use 4k page addressing, 0 for byte addressing
	unsigned int base_high :8;
}__attribute__((packed));
struct GDT_Pointer
{
    uint16_t size;
    uintptr_t base;
}__attribute__((packed));

extern struct GDT_entry* gdt;
extern struct GDT_Pointer *gdt_descriptor;

void initGDT();

#endif