#include <synos/synos.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdio.h>

#ifndef LOGLEVEL // Set loglevel
const enum Log_Level log_level = INFO; // Print all messages including INFO
const bool log_level_d = true; // LOGLEVEL was not defined
#else
const bool log_level_d = false;
#if LOGLEVEL == 0
const enum Log_Level log_level = 0;
#elif LOGLEVEL == 1
const enum Log_Level log_level = 1;
#elif LOGLEVEL == 2
const enum Log_Level log_level = 2;
#elif LOGLEVEL == 3
const enum Log_Level log_level = 3;
#else 
const enum Log_Level log_level = 4;
#endif
#endif
#ifndef LOGENTRY_SIZE
const size_t log_entries_size = DEFAULT_LOG_ENTRY_SIZE;
#else
const size_t log_entries_size = LOGENTRY_SIZE;
#endif


struct Log_Entry
{
    size_t length;
    enum Log_Level level;
    char* string;
    // TODO: add time variables
};

struct Log_Entry* log_entries;
size_t n_free_entry = 0;
bool log_enable = false;

int log_init()
{
    log_entries = (struct Log_Entry*)malloc(sizeof(struct Log_Entry)*log_entries_size);
    if (log_entries == NULL) return 0;
    log_enable = true;
    
    return 1;
}

void pr_log(enum Log_Level level, const char* text, ...)
{
    if (n_free_entry == log_entries_size) panic("Allocated log space reached!");

    size_t i = n_free_entry;
    log_entries[i].length = strlen(text);
    log_entries[i].level = level;

    log_entries[i].string = (char*)malloc(log_entries[i].length);
    memcpy(log_entries[i].string, text, log_entries[i].length+1);

    if (log_entries[i].level <= log_level)
    {
        printf(log_entries[i].string);
        printf("\n");
    }
    n_free_entry++;
}