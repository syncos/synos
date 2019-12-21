#include "interrupts.h"
#include <synos/synos.h>
#include "../cpuid.h"

// PIC related
extern int PIC_Configure(uint8_t offset1, uint8_t offset2);
extern void PIC_SOI(uint8_t irq);
extern void PIC_EOI(uint8_t irq);
extern void PIC_IRQ_save();
extern void PIC_IRQ_kill();
extern void PIC_IRQ_restore();
// APIC related
extern int APIC_Configure(uint8_t offset);
extern void APIC_SOI(uint8_t irq);
extern void APIC_EOI(uint8_t irq);
extern void APIC_IRQ_save();
extern void APIC_IRQ_kill();
extern void APIC_IRQ_restore();

enum IRQ_CONTROLLERS ic_control;

enum IRQ_CONTROLLERS IC_Controller()
{
    if (x64ID.APIC)
        return PIC;
    return PIC;
}

int IC_Configure(enum IRQ_CONTROLLERS controller)
{
    switch (controller)
    {
        case PIC: return PIC_Configure(IRQ_start, IRQ_start+8);
        case APIC: return APIC_Configure(IRQ_start);
        default: panic("Invalid irq controller type");
    }
    return -1;
}

void IC_SOI(uint8_t irq)
{
    switch (ic_control)
    {
        case PIC: return PIC_SOI(irq);
        case APIC: return APIC_SOI(irq);
        default: panic("Invalid irq controller type");
    }
}
void IC_EOI(uint8_t irq)
{
    switch (ic_control)
    {
        case PIC: return PIC_EOI(irq);
        case APIC: return APIC_EOI(irq);
        default: panic("Invalid irq controller type");
    }
}

void IRQ_save()
{
    switch (ic_control)
    {
        case PIC: return PIC_IRQ_save();
        case APIC: return APIC_IRQ_save();
        default: panic("Invalid irq controller type");
    }
}
void IRQ_kill()
{
    switch (ic_control)
    {
        case PIC: return PIC_IRQ_kill();
        case APIC: return APIC_IRQ_kill();
        default: panic("Invalid irq controller type");
    }
}
void IRQ_restore()
{
    switch (ic_control)
    {
        case PIC: return PIC_IRQ_restore();
        case APIC: return APIC_IRQ_restore();
        default: panic("Invalid irq controller type");
    }
}