#include <string.h>
#include <synos/synos.h>

#define STRING_ALLOC_LENGTH 64

void string_append(string_t *s, const char* str, size_t length)
{
    if (s->alloc_length - s->length < length + 1) {
        s->alloc_length += STRING_ALLOC_LENGTH;
        char* newstr = kmalloc(s->alloc_length);
        memcpy(newstr, s->str, s->length);
        kfree(s->str);
        s->str = newstr;
    }
    memcpy(s->str + s->length, str, length);
    s->length += length;
    s->str[s->length] = 0;
}

string_t *newString()
{
    string_t *s = kmalloc(sizeof(string_t));

    s->str = kmalloc(STRING_ALLOC_LENGTH);
    s->length = 0;
    s->alloc_length = STRING_ALLOC_LENGTH;

    s->append = string_append;

    return s;
}