#include <elf/elf.h>
#include <stddef.h>
#include <stdlib.h>

bool FileIsELF(const char* file)
{
    if (file[0] == 0x7F && file[1] == 0x45 && file[2] == 0x4c && file[3] == 0x46) return true;
    return false;
}

struct ELF_HEADER *ParseELF_HEADER(const char* header)
{
    if (!FileIsELF(header)) return NULL;

    struct ELF_HEADER *hdr = (struct ELF_HEADER*)malloc(sizeof(struct ELF_HEADER));

    hdr->header = ((char*)header);
    
    hdr->e_ident = ((char*)header);

    hdr->e_type = &((char*)header)[0x10];
    hdr->e_type_16 = (uint16_t*)hdr->e_type;

    hdr->e_machine = &((char*)header)[0x12];
    hdr->e_machine_16 = (uint16_t*)hdr->e_machine;

    hdr->e_version = &((char*)header)[0x14];
    hdr->e_version_32 = (uint32_t*)hdr->e_version;

    hdr->e_entry = &((char*)header)[0x18];
    hdr->e_entry_ptr = (uintptr_t*)hdr->e_entry;

    int e_flags_start;
    if (hdr->e_ident[EI_CLASS] == 2)
    {
        e_flags_start = 0x30;

        hdr->e_phoff = &((char*)header)[0x20];
        hdr->e_phoff_ptr = (uintptr_t*)hdr->e_phoff;

        hdr->e_shoff = &((char*)header)[0x28];
        hdr->e_shoff_ptr = (uintptr_t*)hdr->e_shoff;
    }
    else
    {
        e_flags_start = 0x24;

        hdr->e_phoff = &((char*)header)[0x1C];
        hdr->e_phoff_ptr = (uintptr_t*)hdr->e_phoff;

        hdr->e_shoff = &((char*)header)[0x20];
        hdr->e_shoff_ptr = (uintptr_t*)hdr->e_shoff;
    }

    hdr->e_flags = &((char*)header)[e_flags_start];
    hdr->e_flags_32 = (uint32_t*)hdr->e_flags;

    hdr->e_ehsize = &((char*)header)[e_flags_start+4];
    hdr->e_ehsize_16 = (uint16_t*)hdr->e_ehsize;

    hdr->e_phentsize = &((char*)header)[e_flags_start+6];
    hdr->e_phentsize_16  = (uint16_t*)hdr->e_phentsize;

    hdr->e_phnum = &((char*)header)[e_flags_start+8];
    hdr->e_phnum_16 = (uint16_t*)hdr->e_phnum;

    hdr->e_shentsize = &((char*)header)[e_flags_start+10];
    hdr->e_shentsize_16 = (uint16_t*)hdr->e_shentsize;

    hdr->e_shnum = &((char*)header)[e_flags_start+12];
    hdr->e_shnum_16 = (uint16_t*)hdr->e_shnum;

    hdr->e_shstrndx = &((char*)header)[e_flags_start+14];
    hdr->e_shstrndx_16 = (uint16_t*)hdr->e_shstrndx;

    return hdr;
}