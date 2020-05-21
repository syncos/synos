#include <synos.h>
#include <mm.h>
#include <slab.h>
#include "acpi.h"
#include <string.h>

const char * rsdp_signature = "RSD PTR ";

char * acpi_oamid = NULL;

RSDP_t * findRSDP()
{
    RSDP_t * p = kmalloc(sizeof(RSDP_t), GFP_KERNEL);
    if (!p)
        return NULL;
    // Try EBDA
    void * ebda = kvs_map(EBDA_START, 0, PAGE_NO_CACHE);
    if (!ebda) {
        kfree(p);
        return NULL;
    }
    for (RSDP_t * cp = ebda; (unsigned long)cp < (unsigned long)ebda + 0x400; cp = (void*)((unsigned long)cp + 16)) {
        if (memcmp(cp, rsdp_signature, 8) == 0) {
            memcpy(p, cp, sizeof(RSDP_t));
            kvs_unmap(ebda, 0);
            goto pfound;
        }
    }
    kvs_unmap(ebda, 0);
    // If no luck with EBDA, try BDA
    void * bda = kvs_map(BDA_START, 5, PAGE_NO_CACHE);
    if (!bda) {
        kfree(p);
        return NULL;
    }
    for (RSDP_t * cp = bda; (unsigned long)cp < (unsigned long)bda + 0x1FFFF; cp = (void*)((unsigned long)cp + 16)) {
        if (memcmp(cp, rsdp_signature, 8) == 0) {
            memcpy(p, cp, sizeof(RSDP_t));
            kvs_unmap(bda, 5);
            goto pfound;
        }
    }
    // No luck
    kvs_unmap(bda, 5);
    return NULL;

    pfound:;
    // Verify checksum
    uintmax_t s = 0;
    for (int i = 0; i < 20; ++i)
        s += ((unsigned char*)p)[i];
    if ((s & 0xFF) != 0) {
        // Checksum incorrect
        kfree(p);
        return NULL;
    }
    if (p->Revision != 0) {
        s = 0;
        for (int i = 20; i < 36; ++i)
            s += ((unsigned char*)p)[i];
        if ((s & 0xFF) != 0) {
            kfree(p);
            return NULL;
        }
    }

    return p;
}

int acpi_init()
{
    apic_init();

    RSDP_t * rsdp = findRSDP();
    if (!rsdp)
        panic("No RSDP table given needed to initalize ACPI");
    acpi_oamid = kmalloc(7, GFP_KERNEL);
    if (acpi_oamid) {
        memcpy(acpi_oamid, rsdp->OEMID, 6);
        acpi_oamid[6] = 0;
        printk(DEBUG, "ACPI OAMID: %s", acpi_oamid);
    }
    else {
        printk(WARNING, "Could not allocate memory for acpi_oamid");
    }

    
    
    return 1;
}