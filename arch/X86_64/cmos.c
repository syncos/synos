#include <synos/arch/arch.h>
#include <synos/arch/io.h>
#include <synos/synos.h>
#include <synos/arch/interrupt.h>
#include <string.h>

#define CMOS_TIME_YEAR_OFFSET 2000

#define CMOS_REG_PORT 0x70
#define CMOS_RW_PORT  0x71

#define CMOS_TIME_SECONDS 0x00
#define CMOS_TIME_MINUTES 0x02
#define CMOS_TIME_HOURS   0x04
#define CMOS_TIME_WEEKDAY 0x06
#define CMOS_TIME_DAY     0x07
#define CMOS_TIME_MONTH   0x08
#define CMOS_TIME_YEAR    0x09

#define CMOS_STATUS_A     0x0A
#define CMOS_STATUS_B     0x0B

uint8_t nmi_state;

uint64_t irqCount;
time_t ctime;

static inline uint8_t cmos_read(uint8_t reg)
{
    outb(CMOS_REG_PORT, reg | nmi_state);
    return inb(CMOS_RW_PORT);
}
static inline void cmos_write(uint8_t reg, uint8_t value)
{
    outb(CMOS_REG_PORT, reg | nmi_state);
    outb(CMOS_RW_PORT, value);
}

static void rtc_irq_init()
{
    bool inEn = false;
    if (interrupt_enabled())
        inEn = true;
    interrupt_disable();

    uint8_t prev;
    prev = cmos_read(CMOS_STATUS_A);
    cmos_write(CMOS_STATUS_A, (prev & 0xF0) | 3); // Generates a pulse of 8192 hz or 122.0703125 uS

    prev = cmos_read(CMOS_STATUS_B);
    cmos_write(CMOS_STATUS_B, prev | 0x40); // Enable IRQ 8

    irqCount = 0;
    if (inEn)
        interrupt_enable();   
}

int arch_time_init()
{
    // Save the nmi state
    nmi_state = inb(CMOS_REG_PORT) & 0x80;
    
    // Clear the ctime struct
    memset(&ctime, 0, sizeof(time_t));
    
    // Then read the initial values
    ctime.seconds = cmos_read(CMOS_TIME_SECONDS);
    ctime.minutes = cmos_read(CMOS_TIME_MINUTES);
    ctime.hours   = cmos_read(CMOS_TIME_HOURS);
    ctime.day     = cmos_read(CMOS_TIME_DAY);
    ctime.month   = cmos_read(CMOS_TIME_MONTH);
    ctime.year    = cmos_read(CMOS_TIME_YEAR);
    ctime.year += CMOS_TIME_YEAR_OFFSET; // Add the offset

    if (ctime.hours & (1 << 7)) {
        ctime.hours &= ~(1UL << 7);
        ctime.hours += 12;
    }

    // Calculate unix time
    ctime.unix_t =  ctime.seconds;
    ctime.unix_t += ctime.minutes * 60;
    ctime.unix_t += ctime.hours * 3600;
    ctime.unix_t += ctime.day * 86400;
    ctime.unix_t += ctime.month * 2629800;
    ctime.unix_t += (ctime.year - 1971) * 31557600;

    rtc_irq_init();

    printk(DEBUG, "RTC initialized");
    return 0;
}

const time_t *arch_gettime()
{
    return &ctime;
}

void ms_update()
{
    if (irqCount >= 1024) {
        ctime.microseconds += 72;
        irqCount = 0;
    }
    ctime.microseconds += 122;

    if (ctime.microseconds - (ctime.milliseconds * 1000) >= 1000)
        ++ctime.milliseconds;
    if (ctime.milliseconds >= 1000) {
        ctime.microseconds -= 1000000;
        ctime.milliseconds -= 1000;
        ++ctime.unix_t;
    }

    outb(CMOS_REG_PORT, 0x0C | nmi_state);
    inb(CMOS_RW_PORT);
}

void nmi_enable()
{
    outb(CMOS_REG_PORT, inb(CMOS_REG_PORT) & 0x7F);
}
void nmi_disable()
{
    outb(CMOS_REG_PORT, inb(CMOS_REG_PORT) | 0x80);
}