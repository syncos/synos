/* MIT License

Copyright (c) 2019 Jacob Paul

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice (including the next
paragraph) shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

*/
#ifndef _INTTYPES_H
#define _INTTYPES_H

/* Define type size */

// Exact width
// Signed
typedef signed char         int8_t;
typedef signed short int    int16_t;
typedef signed int          int32_t;
#ifdef __x86_64__
typedef signed long int int64_t;
#else
typedef signed long long int int64_t;
#endif
#define INT8_MIN -127
#define INT8_MAX 127
#define INT16_MIN -0x7FFF
#define INT16_MAX 0x7FFF
#define INT32_MIN -0x7FFFFFFF
#define INT32_MAX 0x7FFFFFFF
#define INT64_MIN -0x7FFFFFFFFFFFFFFF
#define INT64_MAX 0x7FFFFFFFFFFFFFFF
// Unsigned
typedef unsigned char       uint8_t;
typedef unsigned short int  uint16_t;
typedef unsigned int        uint32_t;
#ifdef __x86_64__
typedef signed long int uint64_t;
#else
typedef signed long long int uint64_t;
#endif
#define UINT8_MAX 0xFF
#define UINT16_MAX 0xFFFF
#define UINT32_MAX 0xFFFFFFFF
#define UINT64_MAX 0xFFFFFFFFFFFFFFFF

// Least width
// Signed
typedef int8_t  int_least8_t;
typedef int16_t int_least16_t;
typedef int32_t int_least32_t;
typedef int64_t int_least64_t;
#define INT_LEAST8_MIN -127
#define INT_LEAST8_MAX 127
#define INT_LEAST16_MIN -0x7FFF
#define INT_LEAST16_MAX 0x7FFF
#define INT_LEAST32_MIN -0x7FFFFFFF
#define INT_LEAST32_MAX 0x7FFFFFFF
#define INT_LEAST64_MIN -0x7FFFFFFFFFFFFFFF
#define INT_LEAST64_MAX 0x7FFFFFFFFFFFFFFF
// Unsigned
typedef uint8_t  uint_least8_t;
typedef uint16_t uint_least16_t;
typedef uint32_t uint_least32_t;
typedef uint64_t uint_least64_t;
#define UINT_LEAST8_MAX 0xFF
#define UINT_LEAST16_MAX 0xFFFF
#define UINT_LEAST32_MAX 0xFFFFFFFF
#define UINT_LEAST64_MAX 0xFFFFFFFFFFFFFFFF

// Fastest
// Signed
typedef int8_t  int_fast8_t;
typedef int16_t int_fast16_t;
typedef int32_t int_fast32_t;
typedef int64_t int_fast64_t;
#define INT_FAST8_MIN -127
#define INT_FAST8_MAX 127
#define INT_FAST16_MIN -0x7FFF
#define INT_FAST16_MAX 0x7FFF
#define INT_FAST32_MIN -0x7FFFFFFF
#define INT_FAST32_MAX 0x7FFFFFFF
#define INT_FAST64_MIN -0x7FFFFFFFFFFFFFFF
#define INT_FAST64_MAX 0x7FFFFFFFFFFFFFFF
// Unsigned
typedef uint8_t  uint_fast8_t;
typedef uint16_t uint_fast16_t;
typedef uint32_t uint_fast32_t;
typedef uint64_t uint_fast64_t;
#define UINT_FAST8_MAX 0xFF
#define UINT_FAST16_MAX 0xFFFF
#define UINT_FAST32_MAX 0xFFFFFFFF
#define UINT_FAST64_MAX 0xFFFFFFFFFFFFFFFF

// Pointer
typedef long int   intptr_t;
#ifdef __x86_64__
#define INTPTR_MAX 0xFFFFFFFFFFFFFFFF
#else
#define INTPTR_MAX 0xFFFFFFFF
#endif

// Short types
// Signed
typedef int8_t  i8;
typedef int16_t i16;
typedef int32_t i32;
typedef int64_t i64;
// Unsigned
typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

#endif