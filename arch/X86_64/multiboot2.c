#include <inttypes.h>
#include <synos/arch/arch.h>
#include <synos/synos.h>
#include "memory.h"
#include "x64.h"
#include "multiboot2.h"

int mboot2Init()
{
    load_sys = MULTIBOOT2;

    return 0;
}