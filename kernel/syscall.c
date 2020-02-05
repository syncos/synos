#include <synos/syscall.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>

#pragma GCC diagnostic ignored "-Wvarargs"

#define DEFAULT_SYSCALL_INT 0x80
#ifdef  SYSCALL_INT
const uint8_t syscall_int = SYSCALL_INT;
#else
const uint8_t syscall_int = DEFAULT_SYSCALL_INT;
#endif

struct Syscall_Entry* *syscall_VT;
size_t syscall_VT_length = 0;

// Syscall functions, mapped to SYSCALL_SYC
int sc_fnc(uint32_t id, ...)
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
    for (register uint32_t i = 0; i < syscall_VT_length; ++i)
    {
        if (syscall_VT[i]->id == id) return (int64_t)i;
    }
    return -1;
}
int syscall_set(uint32_t id, int (*function)(uint32_t, ...))
{
    int64_t index = syscall_find_index(id);
    if (index == -1)
    {
        register struct Syscall_Entry* *newSTR = kmalloc(sizeof(struct Syscall_Entry**)*(syscall_VT_length+1));
        memcpy(newSTR, syscall_VT, sizeof(struct Syscall_Entry**)*(syscall_VT_length));
        kfree(syscall_VT);
        syscall_VT = newSTR;

        syscall_VT[syscall_VT_length] = kmalloc(sizeof(struct Syscall_Entry));
        syscall_VT[syscall_VT_length]->id = id;
        index = syscall_VT_length;
        ++syscall_VT_length;
    }
    syscall_VT[index]->function = function;
    return 0;
}

void* syscall_resolve_function(uint32_t id)
{
    return NULL;
}

void syscall_c()
{
    
}