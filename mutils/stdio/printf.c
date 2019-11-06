#include <stdio.h>
#include "../impl/impl.h"

int printf(const char* restrict format, ...)
{
    // TODO
    return _impl_printf(format);

}