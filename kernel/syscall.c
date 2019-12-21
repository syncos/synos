#include <synos/syscall.h>
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

#define DEFAULT_SYSCALL_INT 0x80
#ifdef  SYSCALL_INT
const uint8_t syscall_int = SYSCALL_INT;
#else
const uint8_t syscall_int = DEFAULT_SYSCALL_INT;
#endif

struct Syscall_Entry* *syscall_VT;
size_t syscall_VT_length = 0;

// Syscall functions, mapped to SYSCALL_SYC
int sc_fnc()
{
    return SYC_RETURN_ACK;
}

int syscall_init()
{
    syscall_VT = kmalloc(1);

    syscall_set(SYSCALL_SYC, sc_fnc);

    return 0;
}

static int64_t syscall_find_index(uint32_t id)
{
    for (uint32_t i = 0; i < syscall_VT_length; ++i)
    {
        if (syscall_VT[i]->id == id) return (int64_t)i;
    }
    return -1;
}
int syscall_set(uint32_t id, void* function)
{
    if (syscall_find_index(id) == -1)
    {
        
    }
    return 0;
}

void* syscall_resolve_function(uint32_t id)
{
    return NULL;
}

void syscall_c()
{
    printf("Syscall!");
}