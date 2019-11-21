#ifndef K_SYSCALL_H
#define K_SYSCALL_H
#include <inttypes.h>

#define SYC_RETURN_ACK 0
#define SYC_RETURN_ERR 1
// Hard coded syscalls
enum SYSCALL_INDEX
{
    SYSCALL_EXT = 0, // Syscall exit program. arg0 : int = exit code
    SYSCALL_EOX,     // Syscall end of execution. Can be used by programs to voluntarily give up execution back to the scheduler. It is recommended to use this syscall instead of irq 0.
    SYSCALL_SYC,     // Syscall management, programs without not in ring 0 will get a protection fault.
    SYSCALL_MEM,     // Memory functions, see synos/memory.h

    SYSCALL_INDEX_SIZE
};

// Functions provided by SYSCALL_SYC
enum SYSCALL_SYC_INDEX
{
    SYSCALL_ADD, // Add syscall
    SYSCALL_RMV, // Remove syscall
    SYSCALL_PRT, // Set syscall port
    SYSCALL_FSI, // Get free syscall id

    SYSCALL_SYC_INDEX_SIZE
};

#ifdef _64BIT_
struct Syscall_Args
{
    uint64_t arg0;
    uint64_t arg1;
    uint64_t arg2;
    uint64_t arg3;
    uint64_t arg4;
    uint64_t arg5;
};
#else
struct Syscall_Args
{
    uint32_t arg0;
    uint32_t arg1;
    uint32_t arg2;
    uint32_t arg3;
    uint32_t arg4;
    uint32_t arg5;
};
#endif

struct Syscall_I
{
    uint32_t id;
    struct Syscall_Args *args;
};

int syscall_init();
int syscall_add(uint32_t id, int (*f)(const struct Syscall_I*));

void syscall_c(const struct Syscall_Args *);
#endif