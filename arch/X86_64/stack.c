#include <mkos/arch/arch.h>
#include <stdlib.h>

uintptr_t MemStack = 0x3FFFFFFF;

#ifdef MEMSTACK_ENABLE
void* memstck_malloc(size_t bytes)
{
    void* pointer = (void*)MemStack -  bytes - 1;

    MemStack -= bytes;

    return pointer;
}
#endif

struct Stacktrace* KernTraceStack()
{
    struct Stacktrace *trace = (struct Stacktrace*)malloc(sizeof(struct Stacktrace));
    struct Stackframe *stk;

    return trace;
}