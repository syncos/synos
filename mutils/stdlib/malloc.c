#include <stdlib.h>
#include <synos/synos.h>

#ifdef MEMSTACK_ENABLE
#include <synos/arch/memory.h>
#endif

void* malloc(size_t bytes)
{
    #ifdef MEMSTACK_ENABLE
    if (!System.MMU_enabled)
    {
        void* adr = memstck_malloc(bytes);
        if (adr != NULL) return adr;
    }
    #endif
    return 0;
}