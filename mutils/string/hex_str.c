#include <string.h>
#include <synos/synos.h>

char* hex_str(uint64_t in)
{
    string_t *out = newString();

    if (in == 0) {
        out->append(out, "0", 1);
        goto end;
    }

    char c;
    while (in > 0)
    {
        c = in & 0xF;
        if (c < 0xA)
            c += '0';
        else
            c = c - 0xA + 'A';
        out->append(out, &c, 1);
        in = in >> 4;
    }

    end:;
    char* str = out->str;
    kfree(out);
    reverse(str);
    return str;
}