#ifndef PLIBC_INTTYPES_H
#define PLIBC_INTTYPES_H

#include <stdint.h>
#include <stddef.h>

#ifdef __LP64__
#   define _PRI64_PREFIX  "l"
#else
#   define _PRI64_PREFIX  "ll"
#endif

/* printf literals */

/* Decimal notation */

#define PRId8       "d"
#define PRId16      "d"
#define PRId32      "d"
#define PRId64      _PRI64_PREFIX "d"

#define PRIdLEAST8  "d"
#define PRIdLEAST16 "d"
#define PRIdLEAST32 "ld"
#define PRIdLEAST64 "lld"

#define PRIdFAST8   PRIdLEAST8
#define PRIdFAST16  PRIdLEAST16
#define PRIdFAST32  PRIdLEAST32
#define PRIdFAST64  PRIdLEAST64

#define PRIi8       "i"
#define PRIi16      "i"
#define PRIi32      "i"
#define PRIi64      _PRI64_PREFIX "i"

#define PRIiLEAST8  "i"
#define PRIiLEAST16 "i"
#define PRIiLEAST32 "li"
#define PRIiLEAST64 "lli"

#define PRIiFAST8   PRIiLEAST8
#define PRIiFAST16  PRIiLEAST16
#define PRIiFAST32  PRIiLEAST32
#define PRIiFAST64  PRIiLEAST64

/* Octal notation */

#define PRIo8       "o"
#define PRIo16      "o"
#define PRIo32      "o"
#define PRIo64      _PRI64_PREFIX "o"

#define PRIoLEAST8  "o"
#define PRIoLEAST16 "o"
#define PRIoLEAST32 "lo"
#define PRIoLEAST64 "llo"

#define PRIoFAST8   PRIoLEAST8
#define PRIoFAST16  PRIoLEAST16
#define PRIoFAST32  PRIoLEAST32
#define PRIoFAST64  PRIoLEAST64

/* Unsigned integers */

#define PRIu8       "u"
#define PRIu16      "u"
#define PRIu32      "u"
#define PRIu64      _PRI64_PREFIX "u"

#define PRIuLEAST8  "u"
#define PRIuLEAST16 "u"
#define PRIuLEAST32 "lu"
#define PRIuLEAST64 "llu"

#define PRIuFAST8   PRIuLEAST8
#define PRIuFAST16  PRIuLEAST16
#define PRIuFAST32  PRIuLEAST32
#define PRIuFAST64  PRIuLEAST64

/* Lowercase hexadecimal notation */

#define PRIx8       "x"
#define PRIx16      "x"
#define PRIx32      "x"
#define PRIx64      _PRI64_PREFIX "x"

#define PRIxLEAST8  "x"
#define PRIxLEAST16 "x"
#define PRIxLEAST32 "lx"
#define PRIxLEAST64 "llx"

#define PRIxFAST8   PRIxLEAST8
#define PRIxFAST16  PRIxLEAST16
#define PRIxFAST32  PRIxLEAST32
#define PRIxFAST64  PRIxLEAST64

/* Uppercase hexadecimal notation */

#define PRIX8       "X"
#define PRIX16      "X"
#define PRIX32      "X"
#define PRIX64      _PRI64_PREFIX "X"

#define PRIXLEAST8  "X"
#define PRIXLEAST16 "X"
#define PRIXLEAST32 "lX"
#define PRIXLEAST64 "llX"

#define PRIXFAST8   PRIXLEAST8
#define PRIXFAST16  PRIXLEAST16
#define PRIXFAST32  PRIXLEAST32
#define PRIXFAST64  PRIXLEAST64

/* intmax_t and uintmax_t literals */

#define PRIdMAX     "lld"
#define PRIiMAX     "lli"
#define PRIoMAX     "llo"
#define PRIuMAX     "llu"
#define PRIxMAX     "llx"
#define PRIXMAX     "llX"

/* intptr_t and uintptr_t literals */
#define PRIdPTR     "ld"
#define PRIiPTR     "li"
#define PRIoPTR     "lo"
#define PRIuPTR     "lu"
#define PRIxPTR     "lx"
#define PRIXPTR     "lX"

/* scanf literals */

/* Decimal notation */
#define SCNd8       "hhd"
#define SCNd16      "hd"
#define SCNd32      "d"
#define SCNd64      _PRI64_PREFIX "d"

#define SCNdLEAST8  "hhd"
#define SCNdLEAST16 "hd"
#define SCNdLEAST32 "ld"
#define SCNdLEAST64 "lld"

#define SCNdFAST8   SCNdLEAST8
#define SCNdFAST16  SCNdLEAST16
#define SCNdFAST32  SCNdLEAST32
#define SCNdFAST64  SCNdLEAST64

#define SCNi8       "hhi"
#define SCNi16      "hi"
#define SCNi32      "i"
#define SCNi64      _PRI64_PREFIX "i"

#define SCNiLEAST8  "hhi"
#define SCNiLEAST16 "hi"
#define SCNiLEAST32 "li"
#define SCNiLEAST64 "lli"

#define SCNiFAST8   SCNiLEAST8
#define SCNiFAST16  SCNiLEAST16
#define SCNiFAST32  SCNiLEAST32
#define SCNiFAST64  SCNiLEAST64

/* Octal notation */
#define SCNo8       "hho"
#define SCNo16      "ho"
#define SCNo32      "o"
#define SCNo64      _PRI64_PREFIX "o"

#define SCNoLEAST8  "hho"
#define SCNoLEAST16 "ho"
#define SCNoLEAST32 "lo"
#define SCNoLEAST64 "llo"

#define SCNoFAST8   SCNoLEAST8
#define SCNoFAST16  SCNoLEAST16
#define SCNoFAST32  SCNoLEAST32
#define SCNoFAST64  SCNoLEAST64

/* Unsigned integers */

#define SCNu8       "hhu"
#define SCNu16      "hu"
#define SCNu32      "u"
#define SCNu64      _PRI64_PREFIX "u"

#define SCNuLEAST8  "hhu"
#define SCNuLEAST16 "hu"
#define SCNuLEAST32 "lu"
#define SCNuLEAST64 "llu"

#define SCNuFAST8   SCNuLEAST8
#define SCNuFAST16  SCNuLEAST16
#define SCNuFAST32  SCNuLEAST32
#define SCNuFAST64  SCNuLEAST64

/* Lowercase hexadecimal notation */

#define SCNx8       "hhx"
#define SCNx16      "hx"
#define SCNx32      "x"
#define SCNx64      _PRI64_PREFIX "x"

#define SCNxLEAST8  "hhx"
#define SCNxLEAST16 "hx"
#define SCNxLEAST32 "lx"
#define SCNxLEAST64 "llx"

#define SCNxFAST8   SCNxLEAST8
#define SCNxFAST16  SCNxLEAST16
#define SCNxFAST32  SCNxLEAST32
#define SCNxFAST64  SCNxLEAST64

/* Uppercase hexadecimal notation */

#define SCNX8       "hhX"
#define SCNX16      "hX"
#define SCNX32      "X"
#define SCNX64      _PRI64_PREFIX "X"

#define SCNXLEAST8  "hhX"
#define SCNXLEAST16 "hX"
#define SCNXLEAST32 "lX"
#define SCNXLEAST64 "llX"

#define SCNXFAST8   SCNXLEAST8
#define SCNXFAST16  SCNXLEAST16
#define SCNXFAST32  SCNXLEAST32
#define SCNXFAST64  SCNXLEAST64

/* intmax_t and uintmax_t literals */

#define SCNdMAX     "lld"
#define SCNiMAX     "lli"
#define SCNoMAX     "llo"
#define SCNuMAX     "llu"
#define SCNxMAX     "llx"
#define SCNXMAX     "llX"

/* intptr_t and uintptr_t literals */
#define SCNdPTR     "ld"
#define SCNiPTR     "li"
#define SCNoPTR     "lo"
#define SCNuPTR     "lu"
#define SCNxPTR     "lx"
#define SCNXPTR     "lX"

/* Typedefs etc */
typedef struct 
    {
        long long quot;
        long long rem;
    } imaxdiv_t;

/* Functions */
extern intmax_t     imaxabs     (intmax_t n);
extern imaxdiv_t    imaxdiv     (intmax_t numerator, intmax_t denominator);
extern intmax_t     strtoimax   (const char*    str, char**     endptr, int base);
extern uintmax_t    strtoumax   (const char*    str, char**     endptr, int base);
extern intmax_t     wcstoimax   (const wchar_t* wcs, wchar_t**  endptr, int base);
extern uintmax_t    wcstoumax   (const wchar_t* wcs, wchar_t**  endptr, int base);

#endif