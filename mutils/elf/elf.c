#include <elf/elf.h>
#include <stdlib.h>
#include <string.h>

struct ELF_OBJ *ParseELF(const char* file, const size_t len)
{
    if(!FileIsELF(file)) return NULL;

    struct ELF_OBJ *obj = (struct ELF_OBJ*)malloc(sizeof(struct ELF_OBJ));

    obj->FILE_LENGTH = len;

    obj->FILE = (char*)malloc(len);
    memcpy(obj->FILE, file, len);

    obj->header = ParseELF_HEADER(obj->FILE);

    return obj;
}