#include <synos.h>
#include "acpi.h"
#include "x64.h"
#include "cpu.h"

static void pic_disable()
{
    outb(PIC2_DATA, 0xFF);
    outb(PIC1_DATA, 0xFF);
}

int apic_init()
{
    if (!(cpu.FI_ECX & CPUID_FEAT_EDX_APIC))
        panic("APIC not supported on this processor, CPUID.01h:EDX : %X", cpu.FI_EDX);
    pic_disable();
    
    return 1;
}