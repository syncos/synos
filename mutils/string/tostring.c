#include <string.h>

int tostring(size_t in, char* out)
{
    size_t len = strlen(out);
    for (size_t i = 0; i < len; i++) out[i] = 0;

    if (in == 0)
    {
        out[0] = '0';
        return 1;
    }
    size_t i;
    for (i = 0; in > 0; i++)
    {
        out[i] = (in % 10) + '0';

        in -= in % 10;
        in /= 10;
    }
    reverse(out);
    return 1;
}