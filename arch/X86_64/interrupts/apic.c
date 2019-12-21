#include "interrupts.h"
#include <synos/arch/io.h>
#include "../cpuid.h"

extern void PIC_disable();

const uintptr_t APIC_base = 0x1000;

#define IA32_APIC_BASE_MSR 0x1B
#define IA32_APIC_BASE_MSR_BSP 0x100 // Processor is a BSP
#define IA32_APIC_BASE_MSR_ENABLE 0x800

static void set_apic_base(uintptr_t apic)
{
    uint32_t edx = 0;
    uint32_t eax = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;

    writeMSR(IA32_APIC_BASE_MSR, eax, edx);
}

int APIC_Configure(uint8_t offset)
{
    PIC_disable();
    set_apic_base(APIC_base); // Set the apic base to recide in low-mem
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

void APIC_disable()
{
    uint32_t eax, edx;
    readMSR(IA32_APIC_BASE_MSR, &eax, &edx);

    edx  = 0;
    eax &= ~(1UL << 11); // Disable APIC
    writeMSR(IA32_APIC_BASE_MSR, eax, edx);
}