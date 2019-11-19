#include <synos/synos.h>
#include "interrupts.h"
#include "controller.h"
#include "pic.h"
#include "apic.h"
#include "../cpuid.h"

enum Interrupt_Controller_Type Controller_Type()
{
    if ((((struct X64_CPUID*)System.cpuid.asp)->FI_EDX & CPUID_FEAT_EDX_APIC) > 0)
        return PIC; //APIC is not currently supported
    return PIC;
}

int IC_INIT()
{
    if (Controller_Type() == APIC)
    {
        return APIC_init();
    }
    return PIC_init();
}

void IC_SOI(uint8_t irq)
{
    if (Controller_Type() == APIC)
    {
        return APIC_SOI(irq);
    }
    return PIC_SOI(irq);
}
void IC_EOI(uint8_t irq)
{
    if (Controller_Type() == APIC)
    {
        return APIC_EOI(irq);
    }
    return PIC_EOI(irq);
}
int IC_isSpurious(uint8_t irq)
{
    if (Controller_Type() == APIC)
    {
        return 0;
    }
    if (PIC_isSpurious(irq)) return 1;
    return 0;
}