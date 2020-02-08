#include "interrupts.h"
#include <synos/synos.h>
#include "../cpu.h"

// PIC related
extern int PIC_Configure(uint8_t offset1, uint8_t offset2);
extern void PIC_SOI(uint8_t irq);
extern void PIC_EOI(uint8_t irq);
extern void PIC_IRQ_save();
extern void PIC_IRQ_kill();
extern void PIC_IRQ_restore();
// APIC related
#ifdef APIC_ENABLE
extern int APIC_Configure(uint8_t offset);
extern void APIC_SOI(uint8_t irq);
extern void APIC_EOI(uint8_t irq);
extern void APIC_IRQ_save();
extern void APIC_IRQ_kill();
extern void APIC_IRQ_restore();
#endif

enum IRQ_CONTROLLERS ic_control;

enum IRQ_CONTROLLERS IC_Controller()
{
    #ifdef APIC_ENABLE
    //if (x64ID.APIC)
        //return APIC; // APIC not fully implemented
    #endif
    return PIC;
}

int IC_Configure(enum IRQ_CONTROLLERS controller)
{
    switch (controller)
    {
        case PIC: return PIC_Configure(IRQ_start, IRQ_start+8);

        #ifdef APIC_ENABLE
        case APIC: return APIC_Configure(IRQ_start); 
        #endif
        default: panic("Invalid irq controller type");
    }
    return -1;
}

void IC_SOI(uint8_t irq)
{
    switch (ic_control)
    {
        case PIC: return PIC_SOI(irq);

        #ifdef APIC_ENABLE
        case APIC: return APIC_SOI(irq);
        #endif
        default: panic("Invalid irq controller type");
    }
}
void IC_EOI(uint8_t irq)
{
    switch (ic_control)
    {
        case PIC: return PIC_EOI(irq);

        #ifdef APIC_ENABLE
        case APIC: return APIC_EOI(irq);
        #endif
        default: panic("Invalid irq controller type");
    }
}

void IRQ_save()
{
    switch (ic_control)
    {
        case PIC: return PIC_IRQ_save();

        #ifdef APIC_ENABLE
        case APIC: return APIC_IRQ_save();
        #endif
        default: panic("Invalid irq controller type");
    }
}
void IRQ_kill()
{
    switch (ic_control)
    {
        case PIC: return PIC_IRQ_kill();

        #ifdef APIC_ENABLE
        case APIC: return APIC_IRQ_kill();
        #endif
        default: panic("Invalid irq controller type");
    }
}
void IRQ_restore()
{
    switch (ic_control)
    {
        case PIC: return PIC_IRQ_restore();

        #ifdef APIC_ENABLE
        case APIC: return APIC_IRQ_restore();
        #endif
        default: panic("Invalid irq controller type");
    }
}