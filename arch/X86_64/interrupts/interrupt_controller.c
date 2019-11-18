#include <synos/synos.h>
#include "interrupts.h"
#include "controller.h"
#include "pic.h"
#include "apic.h"
#include "../cpuid.h"

enum Interrupt_Controller_Type Controller_Type()
{
    if ((((struct X64_CPUID*)System.cpuid.asp)->FI_EDX & CPUID_FEAT_EDX_APIC) > 0)
        return APIC;
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