#ifndef ACPI_H
#define ACPI_H
#include <stdint.h>

struct RSDPDescriptor {
    char Signature[8];
    uint8_t Checksum;
    char OEMID[6];
    uint8_t Revision;
    uint32_t RsdtAddress;

    uint32_t Length;
    uint64_t XsdtAddress;
    uint8_t ExtendedChecksum;
    uint8_t reserved[3];
} __attribute__ ((packed));
typedef struct RSDPDescriptor RSDP_t;

int acpi_init();

extern char * acpi_oamid;

#endif