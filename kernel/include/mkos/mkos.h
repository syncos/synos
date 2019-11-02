#ifndef K_MKOS_H
#define K_MKOS_H
#include <mkos/arch/arch.h>
#include <mkos/arch/cpu.h>
#include <mkos/arch/memory.h>
#include <mkos/log.h>

struct
{
    struct CPUID cpuid;
    struct MEMID memid;
}System;

void startup();
void panic(char*);
#endif