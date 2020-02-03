#ifndef K_SYNOS_H
#define K_SYNOS_H
#include <synos/arch/arch.h>
#include <synos/arch/cpu.h>
#include <synos/arch/memory.h>
#include <synos/log.h>
#include <stdbool.h>

#ifndef VERSION
#define VERSION "NaN"
#define VERSION_NAME "UNDEFINED"
#define VERSION_DOMAIN "UNDEFINED"
#endif

struct SYS_STATE
{
    struct CPUINFO cpuinfo;
    struct MEMID memid;
    bool interrupt_enabled;
    bool MMU_enabled;
};

extern struct SYS_STATE System;

void startup();
void panic(char*);

extern void* kmalloc(size_t bytes);
extern void kfree(void* pointer);
#endif