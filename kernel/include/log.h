#ifndef LOG_H
#define LOG_H
#include <stddef.h>
#include <stdarg.h>

enum Log_Level
{
    FATAL,
    CRITICAL,
    ERROR,
    WARNING,
    INFO,
    DEBUG,
};
struct LogEnt
{
    enum Log_Level level;
    size_t seconds;
    size_t microseconds;
    char* message;
};

#ifndef LOGLEVEL
#define LOGLEVEL INFO
#define LOGLEVEL_NOT_SET
#endif

int printk_init();

void printk(enum Log_Level, const char* str, ...);
void vprintk(enum Log_Level, const char* str, va_list args);

#endif