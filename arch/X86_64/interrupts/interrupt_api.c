#include <synos/synos.h>
#include <synos/arch/interrupt.h>
#include "../memory.h"
#include "interrupts.h"
#include "controller.h"
#include <stdlib.h>

struct IDT_Entry IDT[256]; // Set the IDT table to a static size, since malloc can sometimes return NULL and that would cause a panic.
struct IDT_Entry SYSCALL_IE;

#define SET_INT_ENTRY(i, addr, attri) IDT[i].offset_0 = addr & 0xFFFF; IDT[i].offset_1 = (addr & 0xFFFF0000) >> 16; IDT[i].offset_2 = (addr & 0xFFFF00000000) >> 16; IDT[i].selector = GDT_KERN_CODE_SELECTOR; IDT[i].ist = 0; IDT[i].attr = attri; IDT[i].zero = 0

struct
{
    enum Interrupt_Controller_Type controller;
}Interrupt_Info;

int interrupt_init(uint8_t syscall_port)
{
    if (syscall_port <= 0x40)
        panic("Invalid syscall interrupt id");
    IDT[syscall_port].offset_0 = irq_syscall & 0xFFFF;
    IDT[syscall_port].offset_1 = (irq_syscall & 0xFFFF0000) >> 16;
    IDT[syscall_port].offset_2 = (irq_syscall & 0xFFFF00000000) >> 16;

    IDT[syscall_port].selector = GDT_KERN_CODE_SELECTOR;
    IDT[syscall_port].ist      = 0;
    IDT[syscall_port].attr     = 0b11101110;
    IDT[syscall_port].zero     = 0;

    // Load every CPU exception interrupt
    SET_INT_ENTRY(0,  int_0,  INT_GATE_FAULT);
    SET_INT_ENTRY(1,  int_1,  INT_GATE_TRAP);
    SET_INT_ENTRY(2,  int_2,  INT_GATE_INTERRUPT);
    SET_INT_ENTRY(3,  int_3,  INT_GATE_TRAP);
    SET_INT_ENTRY(4,  int_4,  INT_GATE_TRAP);
    SET_INT_ENTRY(5,  int_5,  INT_GATE_FAULT);
    SET_INT_ENTRY(6,  int_6,  INT_GATE_FAULT);
    SET_INT_ENTRY(7,  int_7,  INT_GATE_FAULT);
    SET_INT_ENTRY(8,  int_8,  INT_GATE_ABORT);
    SET_INT_ENTRY(9,  int_9,  INT_GATE_FAULT);
    SET_INT_ENTRY(10, int_10, INT_GATE_FAULT);
    SET_INT_ENTRY(11, int_11, INT_GATE_FAULT);
    SET_INT_ENTRY(12, int_12, INT_GATE_FAULT);
    SET_INT_ENTRY(13, int_13, INT_GATE_FAULT);
    SET_INT_ENTRY(14, int_14, INT_GATE_FAULT);
    SET_INT_ENTRY(15, int_15, INT_GATE_INTERRUPT);
    SET_INT_ENTRY(16, int_16, INT_GATE_FAULT);
    SET_INT_ENTRY(17, int_17, INT_GATE_FAULT);
    SET_INT_ENTRY(18, int_18, INT_GATE_ABORT);
    SET_INT_ENTRY(19, int_19, INT_GATE_FAULT);
    SET_INT_ENTRY(20, int_20, INT_GATE_FAULT);
    for (int i = 21; i <= 29; i++) { SET_INT_ENTRY(i, int_21_29, INT_GATE_INTERRUPT); }
    SET_INT_ENTRY(30, int_30, INT_GATE_INTERRUPT);
    SET_INT_ENTRY(31, int_31, INT_GATE_INTERRUPT);
    // Load 

    // Set controller
    Interrupt_Info.controller = Controller_Type();
    // Initialize the controller
    IC_INIT();
    
    return 0;
}