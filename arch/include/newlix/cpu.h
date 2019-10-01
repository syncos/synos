#ifndef ARCH_CPU_H
#define ARCH_CPU_H
#include <inttypes.h>

struct CPUID
{
    bool enabled;
};

struct CPUID getCPUID();
extern uint32_t CPUID_enabled();
#endif