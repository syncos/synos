#include <newlix/cpu.h>

struct CPUID getCPUID()
{
    struct CPUID cpu;
    if (CPUID_enabled() == 0)
    {
        cpu.enabled = false;
        return cpu;
    }
}