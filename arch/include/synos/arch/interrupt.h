#ifndef ARCH_INTERRUPT_H
#define ARCH_INTERRUPT_H
#include <inttypes.h>

int interrupt_enabled(); // Returns a value >0 if true
void interrupt_enable();
void interrupt_disable();

// Set the correct interrupts, syscalls etc
int interrupt_init();

#endif