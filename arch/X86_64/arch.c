#include <synos/arch/arch.h>
#include "memory.h"

int arch_init()
{
    // Configure the TSS
    initTSS();
    // Configure and load the GDT
    initGDT();
    return 0;
}