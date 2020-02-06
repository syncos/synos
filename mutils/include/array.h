#ifndef _ARRAY_H
#define _ARRAY_H
#include <stddef.h>

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

Array_t *newArray();

#endif