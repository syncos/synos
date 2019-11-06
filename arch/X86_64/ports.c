#include <mkos/arch/io.h>
#include <inttypes.h>

uint8_t inb(uint32_t port)
{
    uint8_t ret;
    asm volatile ("inb al, dx" : "=r" (ret): "r" (port));
    return ret;
}
void outb(uint32_t port, uint8_t value)
{
    asm volatile ("outb dx, al": :"d" (port), "a" (value));
}