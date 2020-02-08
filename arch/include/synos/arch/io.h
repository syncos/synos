#ifndef ARCH_PORTS_H
#define ARCH_PORTS_H
#include <inttypes.h>
#include <stdbool.h>

uint8_t inb(uint16_t);
void outb(uint16_t, uint8_t);
void io_wait();

#endif