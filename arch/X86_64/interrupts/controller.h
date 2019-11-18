#ifndef _INTERRUPTS_CONTROLLER_H
#define _INTERRUPTS_CONTROLLER_H
enum Interrupt_Controller_Type
{
    PIC,
    APIC,
};
enum Interrupt_Controller_Type Controller_Type();

// Functions for the IC
int IC_INIT();

void IC_SOI(uint8_t); // Interrupt Controller Start Of Interrupt
void IC_EOI(uint8_t); // Interrupt Controller End Of Interrupt
#endif