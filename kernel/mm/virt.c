#include <synos/mm.h>
#include <synos/arch/memory.h>

int vpage_init()
{
    pga_init();
    mem_v_alloc();
    return 0;
}