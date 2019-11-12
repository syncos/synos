#ifndef K_MKOS_H
#define K_MKOS_H
#include <synos/arch/arch.h>
#include <synos/arch/cpu.h>
#include <synos/arch/memory.h>
#include <synos/log.h>

#ifndef VERSION
#define VERSION "NaN"
#define VERSION_NAME "NaN"
#endif

struct SYS_STATE
{
    struct CPUID cpuid;
    struct MEMID memid;
    bool interrupt_enabled;
    bool MMU_enabled;
};

extern struct SYS_STATE System;

void startup();
void panic(char*);
#endif