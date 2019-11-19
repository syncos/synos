#ifndef X86_64_INTERRUPTS_H
#define X86_64_INTERRUPTS_H
#include <inttypes.h>

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