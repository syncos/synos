#include <synos.h>
#include <arch.h>

void panic(const char * str, ...)
{
    va_list vlst;
    va_start(vlst, str);
    printk(FATAL, "Kernel panic encountered!");
    vprintk(FATAL, str, vlst);

    printk(WARNING, "System halted");

    halt();
}