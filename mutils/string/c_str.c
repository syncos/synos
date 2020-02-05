#include <string.h>
#include <synos/synos.h>

char* c_str(size_t in)
{
    string_t *out = newString();
    char c;
    while (in > 0)
    {
        c = (in % 10) + '0';
        out->append(out, &c, 1);
        in -= in % 10;
        in /= 10;
    }
    char* str = out->str;
    kfree(out);
    reverse(str);
    return str;
}

char* toLower(char* str)
{
    size_t len = strlen(str);
    for (size_t i = 0; i < len; ++i)
    {
        switch (str[i])
        {
            case 'A' ... 'Z':
                str[i] += 32;
                break;
        }
    }
    return str;
}