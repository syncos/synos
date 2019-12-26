#ifndef K_SYSCALL_H
#define K_SYSCALL_H
#include <inttypes.h>
#include <stddef.h>

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
    SYSCALL_SET, // Set syscall
    SYSCALL_FSI, // Get free syscall id

    SYSCALL_SYC_INDEX_SIZE
};

struct Syscall_Entry
{
    uint32_t id;
    int (*function)(uint32_t, ...);
};

extern struct Syscall_Entry* *syscall_VT;
extern size_t syscall_VT_length;

int syscall_init();
int syscall_set(uint32_t id, int (*function)(uint32_t, ...));

void syscall_c();
#endif