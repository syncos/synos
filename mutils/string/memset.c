#include <string.h>

void* memset(void* s, int c, size_t n)
{
    for (size_t i = 0; i < n; i++)
    {
        ((unsigned char*)s)[i] = (unsigned char)c;
    }
    return s;
}