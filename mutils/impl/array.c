#include <synos/synos.h>
#include <array.h>
#include <string.h>

#define ARRAY_ALLOC_LENGTH 8

static void array_resize(Array_t* a)
{
    if (a->length >= a->alloc_length) {
        a->alloc_length += ARRAY_ALLOC_LENGTH;
        goto rz;
    }
    else if (a->length < a->alloc_length - ARRAY_ALLOC_LENGTH) {
        a->alloc_length -= ARRAY_ALLOC_LENGTH;
        goto rz;
    }
    else return;

    rz:;
    size_t* narr = kmalloc(a->alloc_length*sizeof(size_t));
    memcpy(narr, a->arr, a->length*sizeof(size_t));

    kfree(a->arr);
    a->arr = narr;
}

void array_push(Array_t *a, size_t value)
{
    a->arr[a->length++] = value;
    array_resize(a);
}
void array_insert(Array_t *a, size_t index, size_t value)
{
    if (index >= a->length)
        return;
    for (size_t i = a->length; i > index; --i)
        a->arr[i] = a->arr[i-1];
    a->arr[index] = value;
    ++a->length;
    array_resize(a);
}

size_t array_pop(Array_t *a)
{
    --a->length;
    array_resize(a);
    return a->arr[a->length];
}
size_t array_pull(Array_t *a, size_t index)
{
    if (index >= a->length)
        return 0;
    size_t value = a->arr[index];
    for (size_t i = index; i < a->length-1; ++i)
        a->arr[i] = a->arr[i+1];
    --a->length;
    array_resize(a);
    return value;
}

Array_t *newArray()
{
    Array_t *a = kmalloc(sizeof(Array_t));
    a->arr = kmalloc(sizeof(size_t)*ARRAY_ALLOC_LENGTH);

    a->alloc_length = ARRAY_ALLOC_LENGTH;
    a->length = 0;
    
    a->push = array_push;
    a->pop = array_pop;
    
    a->insert = array_insert;
    a->pull = array_pull;

    return a;
}