#include <string.h>

int reverse(char* format)
{
    size_t len = strlen(format);
    if (len < 2)
        return 0;
    size_t swN = len / 2;
    if (len % 2 != 0) swN++;
     
    for (size_t i = 0; i < swN; i++)
    {
        format[len - 1 - i] = format[len - 1 - i] ^ format[i];
        format[i] = format[len - 1 - i] ^ format[i];
        format[len - 1 - i] = format[len - 1 - i] ^ format[i];
    }
    
    return 0;
}