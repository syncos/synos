#include <synos/arch/arch.h>
#include <synos/arch/io.h>

#define CMOS_REG_PORT 0x70
#define CMOS_RW_PORT  0x71

uint8_t nmi_state;
uint32_t microsecs;
time_t ctime;

int arch_time_init()
{
    nmi_state = inb(CMOS_REG_PORT) & 0x80;
    microsecs = 0;
    return 0;
}

const time_size_t *arch_gettime()
{

}

void ms_update()
{

}