#include <synos/synos.h>
#include <synos/arch/arch.h>
#include "memory.h"
#include "x64.h"
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

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
    uintptr_t currentSymDiff = address - X64.symbols.elf_sym[currentSymIndex].st_value;
    for (uint32_t i = 1; i < X64.symbols.elf_sym_size / sizeof(struct ELF64_Sym); ++i)
    {
        if (X64.symbols.elf_sym[i].st_value > address || (ELF64_ST_TYPE(X64.symbols.elf_sym[i].st_info) != STT_FUNC && ELF64_ST_TYPE(X64.symbols.elf_sym[i].st_info) != STT_NOTYPE))
            continue;
        if ((ELF64_ST_TYPE(X64.symbols.elf_sym[i].st_info) != STT_FUNC && ELF64_ST_TYPE(X64.symbols.elf_sym[i].st_info) != STT_NOTYPE))
        {
            currentSymIndex = i;
            currentSymDiff = address - X64.symbols.elf_sym[i].st_value;
            continue;
        }
        if (address - X64.symbols.elf_sym[i].st_value < currentSymDiff)
        {
            currentSymIndex = i;
            currentSymDiff = address - X64.symbols.elf_sym[i].st_value;

            if (currentSymDiff == 0)
                break;
        }
    }

    return &X64.symbols.elf_str[X64.symbols.elf_sym[currentSymIndex].st_name];
}
void PrintStackTrace()
{
    printk(FATAL, "Stack trace (most recent call first):");

    struct StackFrame *stk = NULL;
    asm volatile ("movq %0, rbp" : "=r"(stk));

    while (1)
    {
        if (stk == NULL)
            break;
        printk(FATAL, "\t0x%X    %s", stk->rip, TraceName(stk->rip));
        stk = stk->rbp;
    }
}