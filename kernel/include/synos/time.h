#ifndef _TIME_H
#define _TIME_H
#include <inttypes.h>

typedef uint64_t time_size_t;

typedef struct time
{
    time_size_t unix_t;

    time_size_t microseconds;
    time_size_t milliseconds;
    time_size_t seconds;
    time_size_t minutes;
    time_size_t hours;
    time_size_t day;
    time_size_t month;
    time_size_t year;
}time_t;

extern const time_t *time_start;

int ktime_init();
const time_t *ktime();

#endif