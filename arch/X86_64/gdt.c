#include "memory.h"
#include <string.h>

struct GDT_entry gdt_a[GDT_LEN]; // Null entry + ring 0 code and data + ring 3 code and data + tss entry
struct GDT_entry* gdt = &gdt_a[0];

struct GDT_Pointer gdt_d;
struct GDT_Pointer *gdt_descriptor = &gdt_d;

void initGDT()
{
    //memset(gdt, 0, sizeof(struct GDT_entry)*GDT_LEN);
}