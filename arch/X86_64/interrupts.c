#include "interrupts.h"
#include "x64.h"
#include <mm.h>

struct IDT_Entry  IDT[256] __attribute__((aligned(4096)));
struct IDT_Descriptor IDTR __attribute__((aligned(4096)));

const uint8_t IRQ_start = 100;
const uint8_t syscall_isr = 0x80;

#define CMOS_REG_PORT 0x70
static inline void nmi_enable()
{
    outb(CMOS_REG_PORT, inb(CMOS_REG_PORT) & 0x7F);
}
static inline void nmi_disable()
{
    outb(CMOS_REG_PORT, inb(CMOS_REG_PORT) | 0x80);
}

inline void idt_set(uint8_t index, uintptr_t address, uint8_t attributes)
{
    IDT[index].offset_1 = address & 0xFFFF;
    IDT[index].offset_2 = (address & 0xFFFF0000) >> 16;
    IDT[index].offset_3 = (address & 0xFFFF00000000) >> 32;

    IDT[index].selector = GDT_KERN_CODE_SELECTOR;
    IDT[index].type_attr = attributes;
    IDT[index].ist = 0;
    
    IDT[index].zero = 0;
}

int idt_init()
{
    nmi_disable();

    // Start by mapping the exceptions
    // idt_set(0,  (uintptr_t)exc_0,  INT_GATE_FAULT);
    // idt_set(1,  (uintptr_t)exc_1,  INT_GATE_TRAP);
    // idt_set(2,  (uintptr_t)exc_2,  INT_GATE_INTERRUPT);
    // idt_set(3,  (uintptr_t)exc_3,  INT_GATE_TRAP);
    // idt_set(4,  (uintptr_t)exc_4,  INT_GATE_FAULT);
    // idt_set(5,  (uintptr_t)exc_5,  INT_GATE_FAULT);
    // idt_set(6,  (uintptr_t)exc_6,  INT_GATE_FAULT);
    // idt_set(7,  (uintptr_t)exc_7,  INT_GATE_FAULT);
    // idt_set(8,  (uintptr_t)exc_8,  INT_GATE_ABORT);
    // idt_set(9,  (uintptr_t)exc_9,  INT_GATE_FAULT);
    // idt_set(10, (uintptr_t)exc_10, INT_GATE_FAULT);
    // idt_set(11, (uintptr_t)exc_11, INT_GATE_FAULT);
    // idt_set(12, (uintptr_t)exc_12, INT_GATE_FAULT);
    // idt_set(13, (uintptr_t)exc_13, INT_GATE_FAULT);
    // idt_set(14, (uintptr_t)exc_14, INT_GATE_FAULT);
    // idt_set(16, (uintptr_t)exc_16, INT_GATE_FAULT);
    // idt_set(17, (uintptr_t)exc_17, INT_GATE_FAULT);
    // idt_set(18, (uintptr_t)exc_18, INT_GATE_ABORT);
    // idt_set(19, (uintptr_t)exc_19, INT_GATE_FAULT);
    // idt_set(20, (uintptr_t)exc_20, INT_GATE_FAULT);
    // idt_set(30, (uintptr_t)exc_30, INT_GATE_FAULT);

    // // Map the IRQs
    // idt_set(IRQ_start + 0,  (uintptr_t)irq_0,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 1,  (uintptr_t)irq_1,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 2,  (uintptr_t)irq_2,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 3,  (uintptr_t)irq_3,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 4,  (uintptr_t)irq_4,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 5,  (uintptr_t)irq_5,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 6,  (uintptr_t)irq_6,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 7,  (uintptr_t)irq_7,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 8,  (uintptr_t)irq_8,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 9,  (uintptr_t)irq_9,  INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 10, (uintptr_t)irq_10, INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 11, (uintptr_t)irq_11, INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 12, (uintptr_t)irq_12, INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 13, (uintptr_t)irq_13, INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 14, (uintptr_t)irq_14, INT_GATE_INTERRUPT);
    // idt_set(IRQ_start + 15, (uintptr_t)irq_15, INT_GATE_INTERRUPT);

    // // Map syscall
    // idt_set(syscall_isr, (uintptr_t)syscall_fn, INT_GATE_INTERRUPT);

    // Load IDT
    IDTR.limit = 0x1000;
    IDTR.offset = (uint64_t)&IDT;
    asm volatile (
        "lidt [%0]"
        :
        : "r"(&IDTR)
        :
    );

    return 0;
}