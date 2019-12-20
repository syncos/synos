#include "memory.h"
#include <synos/synos.h>
#include <string.h>

struct GDT_entry gdt_a[GDT_LEN]; // Null entry + ring 0 code and data + ring 3 code and data + tss entry
struct GDT_entry* gdt = &gdt_a[0];

struct GDT_entry gdt_ld[GDT_LEN]; // The gdt that actually is loaded

struct GDT_entry *get_gdt_entry(uint16_t index)
{
    if (index >= GDT_LEN)
        return NULL;
    return &gdt[index];
}

void gdt_load()
{
    memcpy(gdt_ld, gdt, sizeof(struct GDT_entry)*GDT_LEN); // Start by copying the data over to gdt_ld

    struct GDT_Pointer desc; // Define the descriptor
    desc.base = (uintptr_t)&gdt_ld;
    desc.size = (sizeof(struct GDT_entry)*GDT_LEN) - 1;

    extern void gdt_switch(struct GDT_Pointer*);
    gdt_switch(&desc); // The actual switch is done at assembly level
}
void gdt_entry_map()
{
    struct GDT_entry *gdt_ent;

    #define gdt_ent_check() if(gdt_ent == NULL) panic("GDT entry index out of range")

    // Fill values for NULL segment
    gdt_ent = get_gdt_entry(GDT_NULL_SELECTOR/8);
    gdt_ent_check();
    gdt_ent->limit_low = 0xFFFF;
    gdt_ent->base_low = 0;
    gdt_ent->base_middle = 0;
    gdt_ent->base_high = 0;
    gdt_ent->access = 0;
    gdt_ent->granularity = 0;

    // Fill values for KERN CODE segment
    gdt_ent = get_gdt_entry(GDT_KERN_CODE_SELECTOR/8);
    gdt_ent_check();
    gdt_ent->limit_low = 0;
    gdt_ent->base_low = 0;
    gdt_ent->base_middle = 0;
    gdt_ent->base_high = 0;
    gdt_ent->access = 0b10011010; // Present, Ring 0, code/data, exec, read.
    gdt_ent->granularity = 0b10101111; // Page granularity, x86-64 flag, limit 16:19

    // Fill values for KERN DATA segment
    gdt_ent = get_gdt_entry(GDT_KERN_DATA_SELECTOR/8);
    gdt_ent_check();
    gdt_ent->limit_low = 0;
    gdt_ent->base_low = 0;
    gdt_ent->base_middle = 0;
    gdt_ent->base_high = 0;
    gdt_ent->access = 0b10010010; // Present, Ring 0, code/data, noexec, write.
    gdt_ent->granularity = 0;

    // Next thing to do is to configure the gdt entries for the programs

    // Fill values for PROG CODE segment
    gdt_ent = get_gdt_entry(GDT_PROG_CODE_SELECTOR/8);
    gdt_ent_check();
    gdt_ent->limit_low = 0;
    gdt_ent->base_low = 0;
    gdt_ent->base_middle = 0;
    gdt_ent->base_high = 0;
    gdt_ent->access = 0b11111110;
    gdt_ent->granularity = 0b10101111;

    // Fill values for PROG DATA segment
    gdt_ent = get_gdt_entry(GDT_PROG_DATA_SELECTOR/8);
    gdt_ent_check();
    gdt_ent->limit_low = 0;
    gdt_ent->base_low = 0;
    gdt_ent->base_middle = 0;
    gdt_ent->base_high = 0;
    gdt_ent->access = 0b11110010;
    gdt_ent->granularity = 0;

    
    // Finally, we need to configure the TSS entry
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
    // Clear gdt
    memset(gdt, 0, sizeof(struct GDT_entry)*GDT_LEN);

    gdt_entry_map(); // Map all gdt entries
    gdt_load(); // Load 
}