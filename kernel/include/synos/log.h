#ifndef SYNOS_LOG_H
#define SYNOS_LOG_H
#include <stddef.h>

#define DEFAULT_LOG_ENTRY_SIZE 512

enum Log_Level
{
    FATAL,
    CRITICAL,
    ERROR,
    WARNING,
    INFO
};

extern const enum Log_Level log_level;
extern const bool log_level_d;

void pr_log(enum Log_Level, const char*, ...);
int log_init();

#endif