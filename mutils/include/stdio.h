#ifndef _STDIO_H
#define _STDIO_H
#include <inttypes.h>

#include <stdfile.h>

extern int printf (const char *__restrict __format, ...);
extern int fprintf (struct FILE *__restrict __stream, const char *__restrict __format, ...);
extern int sprintf (char *__restrict __s, const char *__restrict __format, ...);
extern int snprintf (char *__restrict __s, long unsigned int __maxlen, const char *__restrict __format, ...) __attribute__ ((__format__ (__printf__, 3, 4)));

#endif