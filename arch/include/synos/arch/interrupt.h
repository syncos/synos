#ifndef ARCH_INTERRUPT_H
#define ARCH_INTERRUPT_H
#include <inttypes.h>

int interrupt_enabled(); // Returns a value >0 if true
void interrupt_enable();
void interrupt_disable();

int interrupt_init();

// Define exception interrupt and other special functions


#endif