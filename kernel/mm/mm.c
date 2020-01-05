#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/memory.h>

int mm_init()
{
    pga_init();
    ppage_init();

    return 0;
}