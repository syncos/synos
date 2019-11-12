#include <stdio.h>
#include <inttypes.h>
#include "impl.h"
#include <mkos/arch/io.h>
#include "../stdio/sysio.h"

int _impl_printf(const char* restrict format)
{
    #ifdef PRINTF_FALLBACK
    extern const bool PRINTF_FB_ENABLE;
    if (PRINTF_FB_ENABLE)
    {
        struct PRINTF_FUNC* printf_data = printf_init();
        if (printf_data->enabled) return printf_data->printf(format);
        else return 0;
    }
    #endif

    // TODO: add printf syscall
    return 0;
}