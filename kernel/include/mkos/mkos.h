#ifndef K_MKOS_H
#define K_MKOS_H
#include <mkos/arch/arch.h>
#include <mkos/arch/cpu.h>
#include <mkos/arch/memory.h>
#include <mkos/log.h>

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