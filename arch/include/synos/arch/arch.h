#ifndef ARCH_H
#define ARCH_H
#include <inttypes.h>
#include <stddef.h>

extern const uintptr_t _MemStart;
extern const uintptr_t _MemEnd;
extern uintptr_t MemStack;
extern const uintptr_t _MemSize;

enum ARCH
{
    X86,
    X86_64,
};

extern enum ARCH arch;

extern struct Stacktrace* TraceStack();
extern void PrintStackTrace();
extern int arch_init();

extern int arch_printk_init();
extern void arch_print(const char*, size_t);

#endif