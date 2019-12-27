#include <synos/arch/arch.h>
#include "memory.h"
#include "x64.h"
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
const char* func_noname = "";
static const char* TraceName(uintptr_t address)
{
    if (X64.symbols.elf_sym == NULL || X64.symbols.elf_sym_size / sizeof(struct ELF64_Sym) < 1)
        return func_noname;
    
    uint32_t currentSymIndex = 0;
    for (uint32_t i = 1; i < X64.symbols.elf_sym_size / sizeof(struct ELF64_Sym); ++i)
    {
        if (X64.symbols.elf_sym[i].st_value > address)
            continue;
        if (X64.symbols.elf_sym[i].st_value - address > X64.symbols.elf_sym[currentSymIndex].st_value)
            currentSymIndex = i;
    }

    return &X64.symbols.elf_str[X64.symbols.elf_sym[currentSymIndex].st_name];
}
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
        printf(" ");
        printf(TraceName(stk->rip));
        printf("\n");
        stk = stk->rbp;
    }
}