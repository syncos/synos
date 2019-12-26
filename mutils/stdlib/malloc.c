#include <stdlib.h>
#include <synos/synos.h>

#ifdef MEMSTACK_ENABLE
#include <synos/arch/memory.h>
#endif

void* malloc(size_t bytes)
{
    return NULL;
}