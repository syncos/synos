#ifndef ARCH_PORTS_H
#define ARCH_PORTS_H
#include <inttypes.h>
#include <stdbool.h>

uint8_t inb(uint32_t);
void outb(uint32_t, uint8_t);
void io_wait();

#endif