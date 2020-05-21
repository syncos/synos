#ifndef INTERRUPTS_H
#define INTERRUPTS_H
#include <stdint.h>

#define GDT_LEN (1 + 2 + 2 + 1) // Null entry + ring 0 code and data + ring 3 code and data + tss entry

#define GDT_NULL_SELECTOR 	   0x0000
#define GDT_KERN_CODE_SELECTOR 0x0008
#define GDT_KERN_DATA_SELECTOR 0x0010
#define GDT_PROG_CODE_SELECTOR 0x0018
#define GDT_PROG_DATA_SELECTOR 0x0020
#define GDT_TSS_SELECTOR       0x0028

#define INT_GATE_FAULT      0b10001110
#define INT_GATE_INTERRUPT  INT_GATE_FAULT
#define INT_GATE_ABORT      INT_GATE_FAULT
#define INT_GATE_TRAP       0b10001111
#define INT_GATE_SYSCALL    0b11101110

struct IDT_Entry
{
    uint16_t offset_1;
    uint16_t selector;
    uint8_t  ist;
    uint8_t  type_attr;
    uint16_t offset_2;
    uint32_t offset_3;
    uint32_t zero;
}__attribute__((packed));
struct IDT_Descriptor
{
    uint16_t limit;
    uint64_t offset;
}__attribute__((packed));

extern const uint8_t IRQ_start;
extern const uint8_t syscall_isr;

extern struct IDT_Entry       IDT[];
extern struct IDT_Descriptor  IDTR;

int idt_init();

extern void syscall_fn();

extern void exc_0();
extern void exc_1();
extern void exc_2();
extern void exc_3();
extern void exc_4();
extern void exc_5();
extern void exc_6();
extern void exc_7();
extern void exc_8();
extern void exc_9();
extern void exc_10();
extern void exc_11();
extern void exc_12();
extern void exc_13();
extern void exc_14();
extern void exc_15();
extern void exc_16();
extern void exc_17();
extern void exc_18();
extern void exc_19();
extern void exc_20();
extern void exc_30();

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