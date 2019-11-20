#include "pic.h"
#include <synos/arch/io.h>

int PIC_init()
{
    // Remap PIC

    // Save masks
    uint8_t a1, a2;
    a1 = inb(PIC1_DATA);
    a2 = inb(PIC2_DATA);

    // Init command
    outb(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4);
    io_wait(); // For some older systems
    outb(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4);
    io_wait();

    // Send vector offset
    outb(PIC1_DATA, ICW2_1);
    io_wait();
    outb(PIC2_DATA, ICW2_2);
    io_wait();

    // ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
    outb(PIC1_DATA, 4);
    io_wait();
    // ICW3: tell Slave PIC its cascade identity (0000 0010)
    outb(PIC2_DATA, 2);
    io_wait();

    outb(PIC1_DATA, ICW4_8086);
    io_wait();
    outb(PIC2_DATA, ICW4_8086);
    io_wait();

    outb(PIC1_DATA, a1);    // Restore masks
    outb(PIC2_DATA, a2);

    return 0;
}

static uint16_t PIC_get_irq_reg(int ocw3)
{
    /* OCW3 to PIC CMD to get the register values.  PIC2 is chained, and
     * represents IRQs 8-15.  PIC1 is IRQs 0-7, with 2 being the chain */
    outb(PIC1_COMMAND, ocw3);
    outb(PIC2_COMMAND, ocw3);
    return (inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND);
}
int PIC_isSpurious(uint8_t irq)
{
    uint16_t ISR = PIC_get_irq_reg(PIC_READ_ISR_C);
    if (irq == 7 || irq == 15)
    {
        if (((uint8_t*)&ISR)[0] != 7)
            return 1;
        return 0;
    }
    if (irq == 15)
    {
        if (((uint8_t*)&ISR)[1] != 15)
            return 1;
    }
    return 0;
}

void PIC_SOI(uint8_t irq)
{
    return; // Currently nothing to do
}
void PIC_EOI(uint8_t irq)
{
    if (irq >= 8)
        outb(PIC2_COMMAND, PIC_EOI_C);
    outb(PIC1_COMMAND, PIC_EOI_C);
}