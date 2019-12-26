#include <synos/arch/arch.h>
#include "memory.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

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
    ((char*)pointer)[bytes] = 0;

    return pointer;
}
#endif

struct StackFrame
{
    struct StackFrame* rbp;
    uintptr_t rip;
};
void PrintStackTrace()
{
    printf("Stack trace (most recent call first):\n");

    struct StackFrame *stk = NULL;
    asm volatile ("movq %0, rbp" : "=r"(stk));

    while (1)
    {
        if (stk == NULL)
            break;
        printf(hex_str(stk->rip));
        printf(": RSP = ");
        printf(hex_str((uint64_t)stk));
        printf("\n");
        stk = stk->rbp;
    }
}