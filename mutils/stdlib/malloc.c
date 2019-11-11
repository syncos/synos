#include <stdlib.h>
#include <mkos/mkos.h>

#ifdef MEMSTACK_ENABLE
#include <mkos/arch/memory.h>
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