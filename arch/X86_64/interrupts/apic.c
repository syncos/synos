#include "interrupts.h"
#include <synos/arch/io.h>
#include "../cpuid.h"

extern void PIC_disable();

#define IA32_APIC_BASE_MSR 0x1B
#define IA32_APIC_BASE_MSR_BSP 0x100 // Processor is a BSP
#define IA32_APIC_BASE_MSR_ENABLE 0x800

void set_apic_base(uintptr_t apic)
{
    uint32_t edx = 0;
    uint32_t eax = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;

    writeMSR(IA32_APIC_BASE_MSR, eax, edx);
}
uintptr_t get_apic_base()
{
    uint32_t eax, edx;
    readMSR(IA32_APIC_BASE_MSR, &eax, &edx);

    return (eax & 0xfffff000);
}

int APIC_Configure(uint8_t offset)
{
    PIC_disable();
    set_apic_base(get_apic_base());

    return 0;
}

void APIC_SOI(uint8_t irq)
{

}
void APIC_EOI(uint8_t irq)
{

}

void APIC_IRQ_save()
{

}
void APIC_IRQ_kill()
{

}
void APIC_IRQ_restore()
{
    
}