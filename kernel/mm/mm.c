#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/memory.h>

int mm_init()
{
    ppage_init();
    pga_init();

    return 0;
}