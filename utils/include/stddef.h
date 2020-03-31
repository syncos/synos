#ifndef PLIBC_STDDEF_H
#define PLIBC_STDDEF_H

#include <stdint.h>

typedef intmax_t    ptrdiff_t;
typedef uintmax_t   size_t;
typedef uint16_t    wchar_t;

#define NULL        ((void*)0)

#endif