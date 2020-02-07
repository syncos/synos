#include <string.h>
#include <synos/arch/arch.h>

void* memset(void* s, int c, size_t n)
{
    return arch_memset(s, c, n);
}