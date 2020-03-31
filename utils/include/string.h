#ifndef PLIBC_STRING_H
#define PLIBC_STRING_H

#include <stddef.h>

/* Copying */
extern void *       memcpy      (void * destination, const void * source, size_t num);
extern void *       memmove     (void * destination, const void * source, size_t num);
extern void *       strcpy      (char * destination, const char * source);
extern void *       strncpy     (char * destination, const char * source, size_t num);

/* Concatenation */
extern char *       strcat      (char * destination, const char * source);
extern char *       strncat     (char * destination, const char * source, size_t num);

/* Comparison */
extern int          memcmp      (const void * ptr0, const void * ptr1, size_t num);
extern int          strcmp      (const char * str0, const char * str1);
extern int          strncmp     (const char * str0, const char * str1, size_t num);
extern int          strcoll     (const char * str0, const char * str1);
extern size_t       strxfrm     (char * destination, const char * source, size_t num);

/* Searching */
extern const void * memchr      (const void * ptr, int value, size_t num);
extern char *       strchr      (const char * str, int value);
extern size_t       strcspn     (const char * str0, const char * str1);
extern char *       strpbrk     (const char * str0, const char * str1);
extern char *       strrchr     (const char * str, int value);
extern size_t       strspn      (const char * str0, const char * str1);
extern char *       strstr      (const char * haystack, const char * needle);
extern char *       strtok      (const char * str, const char * delim);

/* Other */
extern void *       memset      (void * ptr, int value, size_t num);
extern char *       strerror    (int errnum);
extern size_t       strlen      (const char * str);

int tostring(size_t in, char* out);
char* c_str(size_t in);
int reverse(char* format);
char* hex_str(uint64_t in);
char* toLower(char*);

typedef struct string
{
    char* str;
    size_t length;
    size_t alloc_length;

    void (*append)(struct string *, const char*, size_t);
}string_t;

string_t *newstring();

typedef struct Array
{
    void   (*push)(struct Array*, size_t);
    void   (*insert)(struct Array*, size_t, size_t);

    size_t (*pop)(struct Array*);
    size_t (*pull)(struct Array*, size_t);

    size_t length;
    size_t* arr;

    size_t alloc_length;
}Array_t;

Array_t *newarray();

#endif