#include <string.h>

int strcmp(const char* s1, const char* s2)
{
    for (size_t i = 0; 1; i++)
    {
        if (s1[i] == 0 && s2[i] == 0) return 0;

        if (s1[i] > s2[i]) return 1;
        if (s1[i] < s2[i]) return -1;
    }
}