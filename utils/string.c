#include <string.h>
#include <slab.h>

void * memcpy (void * destination, const void * source, size_t num)
{
    for (size_t i = 0; i < num; ++i) {
        ((char*)destination)[i] = ((const char*)source)[i];
    }
    return destination;
}
void * memmove (void * destination, const void * source, size_t num)
{
    // TODO: implement memmove
    return destination;
}
void * strcpy (char * destination, const char * source)
{
    for (size_t i = 0; destination[i] != 0 && source[i] != 0; ++i) {
        destination[i] = source[i];
    }
    return destination;
}
void * strncpy (char * destination, const char * source, size_t num)
{
    size_t i;
    for (i = 0; i < num && source[i] != 0; ++i) {
        destination[i] = source[i];
    }
    for (; i < num; ++i) {
        destination[i] = 0;
    }
    return destination;
}

char * strcat (char * destination, const char * source)
{
    size_t l = strlen(destination);
    for (size_t i = 0; ; ++i) {
        destination[l+i] = source[i];
        if (source[i] == 0)
            break;
    }
    return destination;
}
char * strncat (char * destination, const char * source, size_t num)
{
    size_t l = strlen(destination);
    size_t i;
    for (i = 0; i < l && i < num; ++i)
        destination[l+i] = source[i];
    destination[l+i] = 0;
    return destination;
}

int memcmp (const void * ptr0, const void * ptr1, size_t num)
{
    for (size_t i = 0; i < num; ++i) {
        if (((unsigned char *)ptr0)[i] < ((unsigned char *)ptr1)[i])
            return -1;
        if (((unsigned char *)ptr0)[i] > ((unsigned char *)ptr1)[i])
            return 1;
    }
    return 0;
}
int strcmp (const char * str0, const char * str1)
{
    for (size_t i = 0; str0[i] != 0 && str1[i] != 0; ++i) {
        if (((unsigned char *)str0)[i] < ((unsigned char *)str1)[i])
            return -1;
        if (((unsigned char *)str0)[i] > ((unsigned char *)str1)[i])
            return 1;
    }
    return 0;
}
int strncmp (const char * str0, const char * str1, size_t num)
{
    for (size_t i = 0; str0[i] != 0 && str1[i] != 0 && i < num; ++i) {
        if (((unsigned char *)str0)[i] < ((unsigned char *)str1)[i])
            return -1;
        if (((unsigned char *)str0)[i] > ((unsigned char *)str1)[i])
            return 1;
    }
    return 0;
}

void * memset (void * ptr, int value, size_t num)
{
    for (size_t i = 0; i < num; ++i)
        ((char*)ptr)[i] = (char)value;
    return ptr;
}
size_t strlen (const char * str)
{
    size_t i;
    for (i = 0; str[i] != 0; ++i) {}
    return i; 
}

int tostring(size_t in, char* out)
{
    size_t len = strlen(out);
    for (size_t i = 0; i < len; i++) out[i] = 0;

    if (in == 0)
    {
        out[0] = '0';
        return 1;
    }
    size_t i;
    for (i = 0; in > 0; i++)
    {
        out[i] = (in % 10) + '0';

        in -= in % 10;
        in /= 10;
    }
    reverse(out);
    return 1;
}

char* c_str(size_t in)
{
    string_t *out = newstring();
    if (in == 0) {
        out->append(out, "0", 1);
        goto done;
    }
    char c;
    while (in > 0)
    {
        c = (in % 10) + '0';
        out->append(out, &c, 1);
        in -= in % 10;
        in /= 10;
    }
    done:;
    char* str = out->str;
    kfree(out);
    reverse(str);
    return str;
}

char* toLower(char* str)
{
    size_t len = strlen(str);
    for (size_t i = 0; i < len; ++i)
    {
        switch (str[i])
        {
            case 'A' ... 'Z':
                str[i] += 32;
                break;
        }
    }
    return str;
}

int reverse(char* format)
{
    size_t len = strlen(format);
    if (len < 2)
        return 0;
    for (size_t i = 0; i < len/2; ++i)
    {
        format[i] = format[i] ^ format[len-1-i];
        format[len-1-i] = format[i] ^ format[len-1-i];
        format[i] = format[i] ^ format[len-1-i];
    }
    
    return 0;
}

char* hex_str(uint64_t in)
{
    string_t *out = newstring();

    if (in == 0) {
        out->append(out, "0", 1);
        goto end;
    }

    char c;
    while (in > 0)
    {
        c = in & 0xF;
        if (c < 0xA)
            c += '0';
        else
            c = c - 0xA + 'A';
        out->append(out, &c, 1);
        in = in >> 4;
    }

    end:;
    char* str = out->str;
    kfree(out);
    reverse(str);
    return str;
}

#define STRING_ALLOC_LENGTH 64

void string_append(string_t *s, const char* str, size_t length)
{
    if (s->alloc_length - s->length < length + 1) {
        s->alloc_length += STRING_ALLOC_LENGTH;
        char* newstr = kmalloc(s->alloc_length, GFP_KERNEL);
        memcpy(newstr, s->str, s->length);
        kfree(s->str);
        s->str = newstr;
    }
    memcpy(s->str + s->length, str, length);
    s->length += length;
    s->str[s->length] = 0;
}

string_t *newstring()
{
    string_t *s = kmalloc(sizeof(string_t), GFP_KERNEL);

    s->str = kmalloc(STRING_ALLOC_LENGTH, GFP_KERNEL);
    s->length = 0;
    s->alloc_length = STRING_ALLOC_LENGTH;

    s->append = string_append;

    return s;
}

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
    size_t* narr = kmalloc(a->alloc_length*sizeof(size_t), GFP_KERNEL);
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

Array_t *newarray()
{
    Array_t *a = kmalloc(sizeof(Array_t), GFP_KERNEL);
    a->arr = kmalloc(sizeof(size_t)*ARRAY_ALLOC_LENGTH, GFP_KERNEL);

    a->alloc_length = ARRAY_ALLOC_LENGTH;
    a->length = 0;
    
    a->push = array_push;
    a->pop = array_pop;
    
    a->insert = array_insert;
    a->pull = array_pull;

    return a;
}