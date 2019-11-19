#ifndef _INTERRUPTS_APIC_H
#define _INTERRUPTS_APIC_H
#include <inttypes.h>

int APIC_init();

void APIC_SOI(uint8_t);
void APIC_EOI(uint8_t);
#endif