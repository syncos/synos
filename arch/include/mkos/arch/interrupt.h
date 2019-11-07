#ifndef ARCH_INTERRUPT_H
#define ARCH_INTERRUPT_H
#include <inttypes.h>

int interrupts_init();
int interrupt_add(uint32_t id, void (*f)(struct ARGS*));


#endif