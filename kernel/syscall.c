#include <synos/syscall.h>

#define DEFAULT_SYSCALL_INT 0x80
#ifdef  SYSCALL_INT
const uint8_t syscall_int = SYSCALL_INT;
#else
const uint8_t syscall_int = DEFAULT_SYSCALL_INT;
#endif

// Syscall functions, mapped to SYSCALL_SYC
int sc_fnc(const struct Syscall_I *args)
{
    return SYC_RETURN_ACK;
}

int syscall_init()
{
    syscall_add(SYSCALL_SYC, sc_fnc);
}

int syscall_add(uint32_t id, int (*f)(const struct Syscall_I*))
{
    
}

void syscall_c(const struct Syscall_Args *args)
{

}