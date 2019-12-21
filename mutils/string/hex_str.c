#include <string.h>

const char* hex_str(uint64_t in)
{
    char* out = "0x0000000000000000";
    if (in == 0) return out;

    for (int i = 0; i < 8; ++i)
    {
        char* offset = &out[2 + (2*i)];

        uint8_t val = (in & ((uint64_t)0xFF << (56 - (8*i)))) >> (56 - (8*i));
        uint8_t val_0 = val & 0x0F;
        uint8_t val_1 = (val & 0xF0) >> 4;

        if (val_0 > 9) val_0 += 7;
        if (val_1 > 9) val_1 += 7;

        offset[1] = val_0 + '0';
        offset[0] = val_1 + '0';
    }

    return out;
}