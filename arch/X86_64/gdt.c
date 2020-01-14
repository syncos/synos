#include "memory.h"
#include <synos/synos.h>
#include <string.h>

struct GDT_entry* GDT;

struct GDT_entry *get_gdt_entry(uint16_t index)
{
    if (index >= GDT_LEN)
        return NULL;
    return &GDT[index];
}

extern void gdtr_store(void *addr);
static void get_gdt()
{
    struct GDT_Pointer gdtr;
    gdtr_store(&gdtr);
    GDT = (void*)gdtr.base;
}

void gdt_entry_map()
{
    struct GDT_entry *gdt_ent;

    #define gdt_ent_check() if(gdt_ent == NULL) panic("GDT entry index out of range")
    
    // We need to configure the TSS entry
    gdt_ent = get_gdt_entry(GDT_TSS_SELECTOR/8);
    gdt_ent_check();
    
    uintptr_t tss_addr = (uintptr_t)proc_tss; // First, get the address for the tss
    gdt_ent->base_low = tss_addr & 0xFFFF; // Then set the GDT entry base to that address
    gdt_ent->base_middle = (tss_addr & 0xFF0000) >> 16;
    gdt_ent->base_high = (tss_addr & 0xFF000000) >> 24;
    
    gdt_ent->limit_low = sizeof(struct TSS); // Set limit TSS' size

    gdt_ent->access = 0b10001001;
    gdt_ent->granularity = 0b01000000;
}

void initGDT()
{
    get_gdt();
    gdt_entry_map(); // Map all gdt entries
}