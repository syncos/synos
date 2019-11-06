#include <stdio.h>
#include <inttypes.h>
#include "impl.h"
#include <mkos/arch/io.h>
#include "../stdio/sysio.h"

int __sysio_close(FILE* stream)
{

}
int* __sysio_errno(FILE* stream)
{

}
long __sysio_write( FILE* restrict stream, const void* restrict buffer, unsigned long count)
{
    
}
int _impl_printf(const char* restrict format)
{
    extern const bool PRINTF_FB_ENABLE;

    if (PRINTF_FB_ENABLE)
    {
        struct PRINTF_FUNC* printf_data = printf_init();
        if (printf_data->enabled) return printf_data->printf(format);
        else return 0;
    }
}