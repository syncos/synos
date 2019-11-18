#include <inttypes.h>
#define DEFAULT_SYSCALL_IRQ 0x80
#ifdef  SYSCALL_IRQ
const uint8_t syscall_irq = SYSCALL_IRQ;
#else
const uint8_t syscall_irq = DEFAULT_SYSCALL_IRQ;
#endif