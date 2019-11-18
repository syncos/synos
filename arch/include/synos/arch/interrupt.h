#ifndef ARCH_INTERRUPT_H
#define ARCH_INTERRUPT_H
#include <inttypes.h>

extern const uint8_t syscall_irq;

int interrupt_enabled(); // Returns a value >0 if true
void interrupt_enable();
void interrupt_disable();

int interrupt_init(uint8_t syscall_port);
int interrupt_add(uint32_t id, void (*f)(uint32_t id, ...));

// Define exception interrupt and other special functions


#endif