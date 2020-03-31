#ifndef PLIBC_STDINT_H
#define PLIBC_STDINT_H

/* Exact width integer types */
/* Signed */
typedef signed char         int8_t;
typedef short               int16_t;
#ifdef __LP64__
    typedef int                 int32_t;
    typedef long int            int64_t;
#else
    typedef long int            int32_t;
    typedef long long int       int64_t;
#endif
typedef long long int           intmax_t;

/* Unsigned */
typedef unsigned char               uint8_t;
typedef unsigned short              uint16_t;
#ifdef __LP64__
    typedef unsigned int            uint32_t;
    typedef unsigned long int       uint64_t;
#else
    typedef unsigned long int       uint32_t;
    typedef unsigned long long int  uint64_t;
#endif
typedef long long int            intmax_t;
typedef unsigned long long int  uintmax_t;


/* Least width integer types */
/* Signed */
typedef signed char             int_least8_t;
typedef short                   int_least16_t;
typedef long int                int_least32_t;
typedef long long int           int_least64_t;
/* Unsigned */
typedef unsigned char           uint_least8_t;
typedef unsigned short          uint_least16_t;
typedef unsigned long int       uint_least32_t;
typedef unsigned long long int  uint_least64_t;


/* Fastest integer types */
/* Signed */
typedef int_least8_t        int_fast8_t;
typedef int_least16_t       int_fast16_t;
typedef int_least32_t       int_fast32_t;
typedef int_least64_t       int_fast64_t;
/* Unsigned */
typedef uint_least8_t       uint_fast8_t;
typedef uint_least16_t      uint_fast16_t;
typedef uint_least32_t      uint_fast32_t;
typedef uint_least64_t      uint_fast64_t;

/* Pointer-sized integer types */
typedef long                intptr_t;
typedef unsigned long       uintptr_t;

/* Limit macros */

#define  INT8_MIN           -((2 << 7)-1)
#define  INT8_MAX           ((2 << 7)-1)
#define UINT8_MAX           ((2 << 8)-1)

#define  INT16_MIN          -((2 << 15)-1)
#define  INT16_MAX          ((2 << 15)-1)
#define UINT16_MAX          ((2 << 16)-1)

#define  INT32_MIN          -((2 << 31)-1)
#define  INT32_MAX          ((2 << 31)-1)
#define UINT32_MAX          ((2 << 32)-1)

#define  INT64_MIN          -((2 << 63)-1)
#define  INT64_MAX          ((2 << 63)-1)
#define UINT64_MAX          ((2 << 64)-1)

#define  INTMAX_MIN          INT64_MIN
#define  INTMAX_MAX          INT64_MAX
#define UINTMAX_MAX         UINT64_MAX

#define  INT_LEAST8_MIN      INT8_MIN
#define  INT_LEAST8_MAX      INT8_MAX
#define UINT_LEAST8_MAX     UINT8_MAX

#define  INT_LEAST16_MIN     INT16_MIN
#define  INT_LEAST16_MAX     INT16_MAX
#define UINT_LEAST16_MAX    UINT16_MAX

#ifdef __LP64__
#   define  INT_LEAST32_MIN     INT64_MIN
#   define  INT_LEAST32_MAX     INT64_MAX
#   define UINT_LEAST32_MAX    UINT64_MAX
#   define  INT_LEAST64_MIN     INT64_MIN
#   define  INT_LEAST64_MAX     INT64_MAX
#   define UINT_LEAST64_MAX    UINT64_MAX
#else
#   define  INT_LEAST32_MIN     INT32_MIN
#   define  INT_LEAST32_MAX     INT32_MAX
#   define UINT_LEAST32_MAX    UINT32_MAX
#   define  INT_LEAST64_MIN     INT64_MIN
#   define  INT_LEAST64_MAX     INT64_MAX
#   define UINT_LEAST64_MAX    UINT64_MAX
#endif

#define  INT_FAST8_MIN       INT_LEAST8_MIN
#define  INT_FAST8_MAX       INT_LEAST8_MAX
#define UINT_FAST8_MAX      UINT_LEAST8_MAX

#define  INT_FAST16_MIN      INT_LEAST16_MIN
#define  INT_FAST16_MAX      INT_LEAST16_MAX
#define UINT_FAST16_MAX     UINT_LEAST16_MAX

#define  INT_FAST32_MIN      INT_LEAST32_MIN
#define  INT_FAST32_MAX      INT_LEAST32_MAX
#define UINT_FAST32_MAX     UINT_LEAST32_MAX

#define  INT_FAST64_MIN      INT_LEAST64_MIN
#define  INT_FAST64_MAX      INT_LEAST64_MAX
#define UINT_FAST64_MAX     UINT_LEAST64_MAX

#ifdef __LP64__
#   define  INTPTR_MIN          INT64_MIN
#   define  INTPTR_MAX          INT64_MAX
#   define UINTPTR_MAX         UINT64_MAX
#else
#   define  INTPTR_MIN          INT32_MIN
#   define  INTPTR_MAX          INT32_MAX
#   define UINTPTR_MAX         UINT32_MAX
#endif

#define SIZE_MAX            UINTMAX_MAX

#define PTRDIFF_MIN          INTMAX_MIN
#define PTRDIFF_MAX          INTMAX_MAX

#define WCHAR_MIN           0
#define WCHAR_MAX           UINT16_MAX

#endif