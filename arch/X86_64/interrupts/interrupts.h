#ifndef X86_64_INTERRUPTS_H
#define X86_64_INTERRUPTS_H
#include <inttypes.h>

#define INT_GATE_FAULT      0b10001110
#define INT_GATE_INTERRUPT  INT_GATE_FAULT
#define INT_GATE_ABORT      INT_GATE_FAULT
#define INT_GATE_TRAP       0b10001111

extern uintptr_t int_0;
extern uintptr_t int_1;
extern uintptr_t int_2;
extern uintptr_t int_3;
extern uintptr_t int_4;
extern uintptr_t int_5;
extern uintptr_t int_6;
extern uintptr_t int_7;
extern uintptr_t int_8;
extern uintptr_t int_9;
extern uintptr_t int_10;
extern uintptr_t int_11;
extern uintptr_t int_12;
extern uintptr_t int_13;
extern uintptr_t int_14;
extern uintptr_t int_15;
extern uintptr_t int_16;
extern uintptr_t int_17;
extern uintptr_t int_18;
extern uintptr_t int_19;
extern uintptr_t int_20;
extern uintptr_t int_21_29;
extern uintptr_t int_30;
extern uintptr_t int_31;

struct IDT_Entry
{
    uint16_t offset_0;
    uint16_t selector;
    uint8_t  ist;
    uint8_t  attr;
    uint16_t offset_1;
    uint16_t offset_2;
    uint32_t zero;
}__attribute__((packed));

extern struct IDT_Entry IDT[];

extern const uintptr_t irq_syscall;
extern void syscall(uint32_t id, ...);

#endif