#include <inttypes.h>
#define DEFAULT_SYSCALL_INT 0x80
#ifdef  SYSCALL_INT
const uint8_t syscall_int = SYSCALL_INT;
#else
const uint8_t syscall_int = DEFAULT_SYSCALL_INT;
#endif