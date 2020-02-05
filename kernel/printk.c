#include <synos/synos.h>
#include <synos/arch/arch.h>
#include <array.h>
#include <string.h>
#include <stdarg.h>

bool printk_enabled = false;

Array_t *logs;

int printk_init()
{
    if (arch_printk_init() < 0)
        panic("arch_printk_init could not initialize");
    
    logs = newArray();

    printk_enabled = true;
    return 0;
}

void printk(enum Log_Level level, const char* str, ...)
{
    if (!printk_enabled)
        return;
    size_t orgLen = strlen(str);

    string_t *lstr = newString();
    struct LogEnt *log = kmalloc(sizeof(struct LogEnt));
    log->level = level;
    // TODO: add support for timestamps
    log->seconds = 0;
    log->microseconds = 0;

    va_list varLst;
    va_start(varLst, str);

    size_t lstart = 0;
    size_t lcpy = 0;
    char *tempStr;
    for (size_t i = 0; i < orgLen; ++i)
    {
        switch (str[i])
        {
            case '%':
                if (i == orgLen - 1)
                    break;
                lstr->append(lstr, &str[lstart], lcpy);
                lcpy = 0;
                lstart = i + 2;
                switch(str[++i])
                {
                    case 'd':
                    case 'i':
                        tempStr = c_str(va_arg(varLst, int));
                        lstr->append(lstr, tempStr, strlen(tempStr));
                        break;
                    case 'u':
                        tempStr = c_str(va_arg(varLst, unsigned int));
                        lstr->append(lstr, tempStr, strlen(tempStr));
                        break;
                    case 'o':
                        // TODO: implement octals
                        va_arg(varLst, unsigned int); // Needed to be at the right offset
                        break;
                    case 'x':
                        tempStr = toLower(hex_str(va_arg(varLst, unsigned int)));
                        lstr->append(lstr, tempStr, strlen(tempStr));
                        break;
                    case 'X':
                        tempStr = hex_str(va_arg(varLst, unsigned int));
                        lstr->append(lstr, tempStr, strlen(tempStr));
                        break;
                    case 's':
                        tempStr = va_arg(varLst, char*);
                        lstr->append(lstr, tempStr, strlen(tempStr));
                        break;
                    // TODO: finish for all the different types
                    default:
                        lstr->append(lstr, &str[i], 1);
                        break;
                }
                break;
            default:
                ++lcpy;
                break;
        }
    }
    if (lcpy > 0)
        lstr->append(lstr, &str[lstart], lcpy);
    
    if (level <= LOGLEVEL) {
        // TODO: add correct time stamps
        arch_print("[ 0.000000 ] ", 13);

        arch_print(lstr->str, lstr->length);
        arch_print("\n", 1);
    }

    log->message = lstr->str;
    logs->push(logs, (size_t)&log);
    va_end(varLst);
    kfree(lstr);
}