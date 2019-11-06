#ifndef ARCH_PORTS_H
#define ARCH_PORTS_H
#include <inttypes.h>

uint8_t inb(uint32_t);
void outb(uint32_t, uint8_t);

extern const bool PRINTF_FB_ENABLE;
struct PRINTF_FUNC
{
    bool enabled;
    int (*printf)(const char* restrict format);
    int (*toggleCursor)();
    int (*enableCursor)();
    int (*disableCursor)();
    int (*setCursorPos)();
};
struct PRINTF_FUNC* printf_init();

#endif