#include <mkos/arch/arch.h>

uintptr_t MemStack = 0x3FFFFFFF;
void* memstck_malloc(size_t bytes)
{
    void* pointer = (void*)MemStack -  bytes - 1;

    MemStack -= bytes;

    return pointer;
}

struct Stacktrace* KernTraceStack()
{
    struct Stacktrace *trace = (struct Stacktrace*)memstck_malloc(sizeof(struct Stacktrace));
    struct Stackframe *stk;
}