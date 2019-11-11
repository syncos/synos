#ifndef MKOS_LOG_H
#define MKOS_LOG_H
#include <stddef.h>

enum Log_Level
{
    FATAL,
    CRITICAL,
    ERROR,
    WARNING,
    INFO
};

void pr_log(enum Log_Level, char*, ...);
int log_init(size_t);

#endif