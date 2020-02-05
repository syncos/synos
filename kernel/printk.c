#include <synos/synos.h>
#include <synos/arch/arch.h>
#include <array.h>
#include <string.h>
#include <stdarg.h>

bool printk_enabled = false;

Array_t *logs;

int printk_init()
{
    if (arch_printk_init() < 0)
        panic("arch_printk_init could not initialize");
    
    logs = newArray();

    printk_enabled = true;
    return 0;
}

void printk(enum Log_Level level, const char* str, ...)
{
    if (!printk_enabled)
        return;
    // TODO: replace this function
    if (level > LOGLEVEL) {
        arch_print(str, strlen(str));
        arch_print("\n", 1);
    }
}