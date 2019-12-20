#include <synos/synos.h>
#include "../cpuid.h"
#include <synos/arch/interrupt.h>
#include "interrupts.h"
#include "../memory.h"
#include "exceptions.h"

struct IDT_Entry IDT[256];
struct IDT_Desc IDTR;

const uint8_t IRQ_start = 100;

#ifdef SYSCALL_INT
const uint8_t syscall_isr = SYSCALL_INT;
#else
const uint8_t syscall_isr = SYSCALL_ISR_DEFAULT;
#endif

int interrupt_enabled()
{
    return RFLAGS() & (1 << 9);
}

void idt_set(uint8_t index, uintptr_t address, uint8_t attributes)
{
    IDT[index].offset_1 = address & 0xFFFF;
    IDT[index].offset_2 = (address & 0xFFFF0000) >> 16;
    IDT[index].offset_3 = (address & 0xFFFF00000000) >> 32;

    IDT[index].selector = GDT_KERN_CODE_SELECTOR;
    IDT[index].type_attr = attributes;
    
    IDT[index].zero0 = 0;
    IDT[index].zero1 = 0;
}

void idt_map()
{
    // Start by mapping the exceptions
    idt_set(0,  (uintptr_t)exc_0,  INT_GATE_FAULT);
    idt_set(1,  (uintptr_t)exc_1,  INT_GATE_TRAP);
    idt_set(2,  (uintptr_t)exc_2,  INT_GATE_INTERRUPT);
    idt_set(3,  (uintptr_t)exc_3,  INT_GATE_TRAP);
    idt_set(4,  (uintptr_t)exc_4,  INT_GATE_FAULT);
    idt_set(5,  (uintptr_t)exc_5,  INT_GATE_FAULT);
    idt_set(6,  (uintptr_t)exc_6,  INT_GATE_FAULT);
    idt_set(7,  (uintptr_t)exc_7,  INT_GATE_FAULT);
    idt_set(8,  (uintptr_t)exc_8,  INT_GATE_ABORT);
    idt_set(9,  (uintptr_t)exc_9,  INT_GATE_FAULT);
    idt_set(10, (uintptr_t)exc_10, INT_GATE_FAULT);
    idt_set(11, (uintptr_t)exc_11, INT_GATE_FAULT);
    idt_set(12, (uintptr_t)exc_12, INT_GATE_FAULT);
    idt_set(13, (uintptr_t)exc_13, INT_GATE_FAULT);
    idt_set(14, (uintptr_t)exc_14, INT_GATE_FAULT);
    idt_set(16, (uintptr_t)exc_16, INT_GATE_FAULT);
    idt_set(17, (uintptr_t)exc_17, INT_GATE_FAULT);
    idt_set(18, (uintptr_t)exc_18, INT_GATE_ABORT);
    idt_set(19, (uintptr_t)exc_19, INT_GATE_FAULT);
    idt_set(20, (uintptr_t)exc_20, INT_GATE_FAULT);
    idt_set(30, (uintptr_t)exc_30, INT_GATE_FAULT);

    // Map the IRQs
    idt_set(IRQ_start + 0,  (uintptr_t)irq_0,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 1,  (uintptr_t)irq_1,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 2,  (uintptr_t)irq_2,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 3,  (uintptr_t)irq_3,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 4,  (uintptr_t)irq_4,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 5,  (uintptr_t)irq_5,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 6,  (uintptr_t)irq_6,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 7,  (uintptr_t)irq_7,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 8,  (uintptr_t)irq_8,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 9,  (uintptr_t)irq_9,  INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 10, (uintptr_t)irq_10, INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 11, (uintptr_t)irq_11, INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 12, (uintptr_t)irq_12, INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 13, (uintptr_t)irq_13, INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 14, (uintptr_t)irq_14, INT_GATE_INTERRUPT);
    idt_set(IRQ_start + 15, (uintptr_t)irq_15, INT_GATE_INTERRUPT);

    // Map syscall
    idt_set(syscall_isr, (uintptr_t)syscall_fn, INT_GATE_INTERRUPT);
}
int interrupt_init()
{
    // Check that the current syscall isn't in conflict with the IRQs
    if (IRQ_start <= syscall_isr && syscall_isr < (IRQ_start+16))
        panic("Syscall ISR in conflict with IRQ values");
    if (syscall_isr <= 31)
        panic("Conflict between syscall_isr value and exception");
    // Map the idt
    idt_map();
    // Configure the irq controller
    IC_Configure(IC_Controller());

    IDTR.limit = 0x1000;
    IDTR.offset = (uint64_t)&IDT;

    extern void IDT_load(void* idtr);
    IDT_load((void*)&IDTR);

    return 0;
}