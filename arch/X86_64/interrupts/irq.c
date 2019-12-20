#include "interrupts.h"
#include <synos/synos.h>
#include "../cpuid.h"

// PIC related
extern int PIC_Configure(uint8_t offset1, uint8_t offset2);
extern void PIC_SOI(uint8_t irq);
extern void PIC_EOI(uint8_t irq);

enum IRQ_CONTROLLERS IC_Controller()
{
    // if ((((struct X64_CPUID*)System.cpuid.asp)->FI_EDX & CPUID_FEAT_EDX_APIC) > 0)
    //     return APIC;
    return PIC;
}

int IC_Configure(enum IRQ_CONTROLLERS controller)
{
    switch (controller)
    {
        case PIC: return PIC_Configure(IRQ_start, IRQ_start+8);
        default: panic("Invalid irq controller type");
    }
    return -1;
}

void IC_SOI()
{

}
void IC_EOI()
{

}