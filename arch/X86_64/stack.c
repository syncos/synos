#include <synos/arch/arch.h>
#include <stdlib.h>

bool MemStack_init = false;
uintptr_t MemStack;

#ifdef MEMSTACK_ENABLE
void* memstck_malloc(size_t bytes)
{
    if (!MemStack_init)
    {
        MemStack = _MemEnd + 64; // Padding just in case
        MemStack_init = true;
    }
    void* pointer = (void*)MemStack;

    MemStack += bytes + 1;

    return pointer;
}
#endif

struct Stacktrace* KernTraceStack()
{
    struct Stacktrace *trace = (struct Stacktrace*)malloc(sizeof(struct Stacktrace));
    struct Stackframe *stk;

    return trace;
}