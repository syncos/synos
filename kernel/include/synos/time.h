#ifndef _TIME_H
#define _TIME_H
#include <inttypes.h>

typedef uint64_t time_size_t;

typedef struct time
{
    // Rolls back to 0 after one second
    time_size_t microseconds;
    time_size_t milliseconds;
    // Seconds since 1971
    time_size_t unix_t;

    // DO NOT USE
    uint8_t seconds;
    uint8_t minutes;
    uint8_t hours;
    uint8_t day;
    uint8_t month;
    uint8_t year;
}time_t;

extern const time_t *time_start;

int ktime_init();
const time_t *ktime();

#endif