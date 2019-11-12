#include <synos/synos.h>
#include <stdlib.h>
#include <inttypes.h>

struct Log
{
    size_t length;
    char* string;
    // TODO: add time variables
};

char* log_buffer;
char** log_pointer;
bool log_enable = false;

int log_init(size_t buffer)
{
    log_buffer = (char*)malloc(buffer);
    
    return 1;
}

void pr_log(enum Log_Level level, char* text, ...)
{

}