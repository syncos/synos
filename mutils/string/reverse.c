#include <string.h>

int reverse(char* format)
{
    size_t len = strlen(format);
    if (len < 2)
        return 0;
    for (size_t i = 0; i < len/2; ++i)
    {
        format[i] = format[i] ^ format[len-1-i];
        format[len-1-i] = format[i] ^ format[len-1-i];
        format[i] = format[i] ^ format[len-1-i];
    }
    
    return 0;
}