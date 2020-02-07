#include <string.h>
#include <synos/arch/arch.h>

void* memcpy(register void* s1, register const void* s2, register size_t n)
{
    return arch_memcpy(s1, s2, n);
}