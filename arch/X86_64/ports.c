#include <synos/arch/io.h>
#include <inttypes.h>

char  portLocked[65536];
bool portInit = false;

int port_compare_exchange(char* ptr, char compare, char exchange)
{
    return __atomic_compare_exchange_n(ptr, &compare, exchange, 0, __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
}
void port_store(char* ptr, char value)
{
    __atomic_store_n(ptr, value, __ATOMIC_SEQ_CST);
}
void initPorts()
{
    for (int i = 0; i < 65536; i++) portLocked[i] = 0;
    portInit = true;
}
void port_lock(uint32_t port)
{
    if(!portInit) initPorts();
    while (!port_compare_exchange(&portLocked[port], 0, 1)) {}
}
void port_unlock(uint32_t port)
{
    if(!portInit) initPorts();
    port_store(&portLocked[port], 0);
}

uint8_t inb(uint32_t port)
{
    port_lock(port);
    uint8_t ret;
    asm volatile ("inb al, dx" : "=r" (ret): "r" (port));
    return ret;
    port_unlock(port);
}
void outb(uint32_t port, uint8_t value)
{
    port_lock(port);
    asm volatile ("outb dx, al": :"d" (port), "a" (value));
    port_unlock(port);
}