#include <string.h>

void* memcpy(register void* s1, register const void* s2, register size_t n)
{
    for (register size_t i = 0; i < n; ++i)
    {
        ((char*)s1)[i] = ((char*)s2)[i];
    }
    return s1;
}