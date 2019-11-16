#include <stdio.h>
#include <inttypes.h>
#include "impl.h"
#include <synos/arch/io.h>
#include "../stdio/sysio.h"

int _impl_printf(const char* restrict format)
{
    #ifdef PRINTF_FALLBACK
    extern const bool PRINTF_FB_ENABLE;
    if (PRINTF_FB_ENABLE)
    {
        if (printf_fallback_fn.enabled) return printf_fallback_fn.printf(format);
        else return 0;
    }
    #endif

    // TODO: add printf syscall
    return 0;
}