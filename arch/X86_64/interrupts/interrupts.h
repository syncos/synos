#ifndef X64_INTERRUPTS_H
#define X64_INTERRUPTS_H
#include <inttypes.h>

#define SYSCALL_ISR_DEFAULT 0x80

#define INT_GATE_FAULT      0b10001110
#define INT_GATE_INTERRUPT  INT_GATE_FAULT
#define INT_GATE_ABORT      INT_GATE_FAULT
#define INT_GATE_TRAP       0b10001111
#define INT_GATE_SYSCALL    0b11101110

enum IRQ_CONTROLLERS
{
    PIC,
    APIC
};

struct IDT_Entry
{
    uint16_t offset_1;
    uint16_t selector;
    uint8_t zero0;
    uint8_t type_attr;
    uint16_t offset_2;
    uint32_t offset_3;
    uint32_t zero1;
}__attribute__((packed));
struct IDT_Desc
{
    uint16_t limit;
    uint64_t offset;
}__attribute__((packed));

extern const uint8_t IRQ_start;
extern const uint8_t syscall_isr;

extern struct IDT_Entry IDT[];
extern struct IDT_Desc IDTR;

enum IRQ_CONTROLLERS IC_Controller();
int IC_Configure(enum IRQ_CONTROLLERS controller);

extern void syscall_fn();

extern void irq_0();
extern void irq_1();
extern void irq_2();
extern void irq_3();
extern void irq_4();
extern void irq_5();
extern void irq_6();
extern void irq_7();
extern void irq_8();
extern void irq_9();
extern void irq_10();
extern void irq_11();
extern void irq_12();
extern void irq_13();
extern void irq_14();
extern void irq_15();

#endif