#include <synos/mm.h>
#include <synos/arch/memory.h>

bool MemStack_init = false;
bool MemStack_enable = true;
uintptr_t MemStack;

void* memstck_malloc(size_t bytes)
{
    if (!MemStack_enable)
        return NULL;
    if (!MemStack_init)
    {
        MemStack = _MemEnd + 64; // Padding just in case
        MemStack_init = true;
    }
    if (MemStack >= 0x200000)
    {
        MemStack_enable = false;
        return NULL;
    }
    if (MemStack + bytes >= 0x200000)
        return NULL;
    void* pointer = (void*)MemStack;

    MemStack += bytes + 1;
    ((char*)pointer)[bytes] = 0;

    return pointer;
}

void memstck_disable()
{
    MemStack_enable = false;
}