#ifndef K_SYNOS_H
#define K_SYNOS_H
#include <synos/arch/arch.h>
#include <synos/arch/cpu.h>
#include <synos/arch/memory.h>
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

void *kmalloc(size_t bytes);
void  kfree(void* address);

enum Log_Level
{
    FATAL,
    CRITICAL,
    ERROR,
    WARNING,
    INFO
};
struct LogEnt
{
    enum Log_Level level;
    size_t seconds;
    size_t microseconds;
    char* message;
};

#ifndef LOGLEVEL
#define LOGLEVEL INFO
#define LOGLEVEL_NOT_SET
#endif

int printk_init();

void printk(enum Log_Level, const char* str, ...);

#endif