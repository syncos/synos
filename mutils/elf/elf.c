#include <elf/elf.h>
#include <stdlib.h>
#include <string.h>

struct ELF_OBJ *ParseELF(const char* file, const size_t len)
{
    if(!FileIsELF(file)) return NULL;

    struct ELF_OBJ *obj = (struct ELF_OBJ*)kmalloc(sizeof(struct ELF_OBJ));

    obj->FILE_LENGTH = len;

    obj->FILE = (char*)kmalloc(len);
    memcpy(obj->FILE, file, len);

    obj->header = ParseELF_HEADER(obj->FILE);
    obj->program_headers = ParseELF_PRG_HEADER(obj->header, (char*)((uintptr_t)obj->FILE + obj->header->e_phoff));
    obj->section_headers = ParseELF_SCT_HEADER(obj->header, (char*)((uintptr_t)obj->FILE + obj->header->e_shoff));

    return obj;
}