#include <elf/elf.h>
#include <synos/arch/cpu.h>
#include <stddef.h>
#include <stdlib.h>

bool FileIsELF(const char* file)
{
    if (file[0] == 0x7F && file[1] == 0x45 && file[2] == 0x4c && file[3] == 0x46) return true;
    return false;
}

static uint16_t swap_uint16(uint16_t val) 
{
    return (val << 8) | (val >> 8 );
}
static uint32_t swap_uint32(uint32_t val)
{
    val = ((val << 8) & 0xFF00FF00 ) | ((val >> 8) & 0xFF00FF ); 
    return (val << 16) | (val >> 16);
}
static uintptr_t swap_uintptr(uintptr_t val)
{
    uintptr_t retVal;
    for (int i = sizeof(uintptr_t)-1; i >= 0; i--)
    {
        ((char*)&retVal)[(sizeof(uintptr_t)-1)-i] = ((char*)&val)[i];
    }
    return retVal;
}

struct ELF_HEADER *ParseELF_HEADER(const char* header)
{
    if (!FileIsELF(header)) return NULL;

    struct ELF_HEADER *hdr = (struct ELF_HEADER*)kmalloc(sizeof(struct ELF_HEADER));

    hdr->header     = ((char*)header);
    hdr->e_ident    = ((char*)header);
    hdr->e_type     = *(uint16_t*) &((char*)header)[0x10];
    hdr->e_machine  = *(uint16_t*) &((char*)header)[0x12];
    hdr->e_version  = *(uint32_t*) &((char*)header)[0x14];

    int e_flags_start;
    hdr->e_entry    = *(uintptr_t*)&((char*)header)[0x18];
    if (hdr->e_ident[EI_CLASS] == 2)
    {
        e_flags_start = 0x30;

        hdr->e_phoff = *(uintptr_t*)&((char*)header)[0x20];
        hdr->e_shoff = *(uintptr_t*)&((char*)header)[0x28];
    }
    else
    {
        e_flags_start = 0x24;

        hdr->e_phoff = *(uintptr_t*)&((char*)header)[0x1C];
        hdr->e_shoff = *(uintptr_t*)&((char*)header)[0x20];
    }

    hdr->e_flags        = *(uint32_t*)&((char*)header)[e_flags_start];
    hdr->e_ehsize       = *(uint16_t*)&((char*)header)[e_flags_start+4];
    hdr->e_phentsize    = *(uint16_t*)&((char*)header)[e_flags_start+6];
    hdr->e_phnum        = *(uint16_t*)&((char*)header)[e_flags_start+8];
    hdr->e_shentsize    = *(uint16_t*)&((char*)header)[e_flags_start+10];
    hdr->e_shnum        = *(uint16_t*)&((char*)header)[e_flags_start+12];
    hdr->e_shstrndx     = *(uint16_t*)&((char*)header)[e_flags_start+14];

    if ((isLittleEndian && hdr->e_ident[EI_DATA] == 2) || (isBigEndian && hdr->e_ident[EI_DATA] == 1)) // The elf file is not in the same format as the cpu, what consequences this has for the caller is up to it.
    {
        hdr->e_type      = swap_uint16(hdr->e_type);
        hdr->e_machine   = swap_uint16(hdr->e_machine);
        hdr->e_machine   = swap_uint16(hdr->e_machine);
        hdr->e_version   = swap_uint32(hdr->e_version);

        hdr->e_entry     = swap_uintptr(hdr->e_entry);
        hdr->e_phoff     = swap_uintptr(hdr->e_phoff);
        hdr->e_shoff     = swap_uintptr(hdr->e_phoff);

        hdr->e_flags     = swap_uint32(hdr->e_flags);
        hdr->e_ehsize    = swap_uint16(hdr->e_ehsize);
        hdr->e_phentsize = swap_uint16(hdr->e_phentsize);
        hdr->e_phnum     = swap_uint16(hdr->e_phnum);
        hdr->e_shentsize = swap_uint16(hdr->e_shentsize);
        hdr->e_shnum     = swap_uint16(hdr->e_shnum);
        hdr->e_shstrndx  = swap_uint16(hdr->e_shstrndx);
    }

    return hdr;
}

struct ELF_PROGRAM_HEADER* ParseELF_PRG_HEADER(const struct ELF_HEADER* hdr, char* prg_hdr_start)
{
    struct ELF_PROGRAM_HEADER* prg_hdr = (struct ELF_PROGRAM_HEADER*)kmalloc(sizeof(struct ELF_PROGRAM_HEADER) * hdr->e_phnum);

    int hdr_ent_size;
    int p_offset_offset;
    if (hdr->e_ident[EI_CLASS] == 2) 
    {
        hdr_ent_size = 0x38;
        p_offset_offset = 0x08;
    }
    else
    {
        hdr_ent_size = 0x20;
        p_offset_offset = 0x04;
    }

    for (uint16_t i = 0; i < hdr->e_phnum; i++)
    {
        char* hdr_ent = prg_hdr_start + hdr_ent_size*i;

        prg_hdr[i].header = hdr_ent;
        prg_hdr[i].header_length = hdr_ent_size;

        prg_hdr[i].p_type = *(uint32_t*)hdr_ent;

        prg_hdr[i].p_offset = *(uintptr_t*)&hdr_ent[p_offset_offset];
        if (hdr->e_ident[EI_CLASS] == 2) 
        {
            prg_hdr[i].p_vaddr  = *(uintptr_t*)&hdr_ent[0x10];
            prg_hdr[i].p_paddr  = *(uintptr_t*)&hdr_ent[0x18];
            prg_hdr[i].p_filesz = *(uintptr_t*)&hdr_ent[0x20];
            prg_hdr[i].p_memsz  = *(uintptr_t*)&hdr_ent[0x28];
            prg_hdr[i].p_align  = *(uintptr_t*)&hdr_ent[0x30];

            prg_hdr[i].p_flags = *(uint32_t*)&hdr_ent[0x04];
        }
        else  
        {
            prg_hdr[i].p_vaddr  = *(uintptr_t*)&hdr_ent[0x08];
            prg_hdr[i].p_paddr  = *(uintptr_t*)&hdr_ent[0x0C];
            prg_hdr[i].p_filesz = *(uintptr_t*)&hdr_ent[0x10];
            prg_hdr[i].p_memsz  = *(uintptr_t*)&hdr_ent[0x14];
            prg_hdr[i].p_align  = *(uintptr_t*)&hdr_ent[0x1C];

            prg_hdr[i].p_flags = *(uint32_t*)&hdr_ent[0x18];
        }

        if ((isLittleEndian && hdr->e_ident[EI_DATA] == 2) || (isBigEndian && hdr->e_ident[EI_DATA] == 1)) // Endian mismatch
        {
            prg_hdr[i].p_type       = swap_uint32(prg_hdr[i].p_type);
            prg_hdr[i].p_flags      = swap_uint32(prg_hdr[i].p_flags);

            prg_hdr[i].p_offset     = swap_uintptr(prg_hdr[i].p_offset);
            prg_hdr[i].p_vaddr      = swap_uintptr(prg_hdr[i].p_vaddr);
            prg_hdr[i].p_paddr      = swap_uintptr(prg_hdr[i].p_paddr);
            prg_hdr[i].p_filesz     = swap_uintptr(prg_hdr[i].p_filesz);
            prg_hdr[i].p_memsz      = swap_uintptr(prg_hdr[i].p_memsz);
            prg_hdr[i].p_align      = swap_uintptr(prg_hdr[i].p_align);
        }
    }

    return prg_hdr;
}
struct ELF_SECTION_HEADER* ParseELF_SCT_HEADER(const struct ELF_HEADER* hdr, char* sct_hdr_start)
{
    struct ELF_SECTION_HEADER *sct_hdr = (struct ELF_SECTION_HEADER*)kmalloc(sizeof(struct ELF_SECTION_HEADER) * hdr->e_shnum);

    int hdr_ent_size;
    if (hdr->e_ident[EI_CLASS] == 2)
        hdr_ent_size = 0x40;
    else
        hdr_ent_size = 0x28;

    for (uint16_t i = 0; i < hdr->e_shnum; ++i)
    {
        char* ent = sct_hdr_start + hdr_ent_size*i;

        sct_hdr[i].sh_name      = *(uint32_t*)ent;
        sct_hdr[i].sh_type      = *(uint32_t*)&ent[0x04];

        sct_hdr[i].sh_flags     = *(uintptr_t*)&ent[0x08];
        sct_hdr[i].sh_addr      = *(uintptr_t*)&ent[0x08 + sizeof(uintptr_t)];
        sct_hdr[i].sh_offset    = *(uintptr_t*)&ent[0x08 + (sizeof(uintptr_t)*2)];
        sct_hdr[i].sh_size      = *(uintptr_t*)&ent[0x08 + (sizeof(uintptr_t)*3)];
        
        register uint8_t sh_link_offset = 0x08 + (sizeof(uintptr_t)*4);

        sct_hdr[i].sh_link      = *(uint32_t*)&ent[sh_link_offset];
        sct_hdr[i].sh_info      = *(uint32_t*)&ent[sh_link_offset + sizeof(uint32_t)];
        
        sct_hdr[i].sh_addralign = *(uintptr_t*)&ent[sh_link_offset + (sizeof(uint32_t)*2)];
        sct_hdr[i].sh_entsize   = *(uintptr_t*)&ent[sh_link_offset + (sizeof(uint32_t)*2) + sizeof(uintptr_t)];

        if ((isLittleEndian && hdr->e_ident[EI_DATA] == 2) || (isBigEndian && hdr->e_ident[EI_DATA] == 1)) // Endian mismatch
        {
            sct_hdr[i].sh_name      = swap_uint32(sct_hdr[i].sh_name);
            sct_hdr[i].sh_type      = swap_uint32(sct_hdr[i].sh_type);

            sct_hdr[i].sh_flags     = swap_uintptr(sct_hdr[i].sh_flags);
            sct_hdr[i].sh_addr      = swap_uintptr(sct_hdr[i].sh_addr);
            sct_hdr[i].sh_offset    = swap_uintptr(sct_hdr[i].sh_flags);
            sct_hdr[i].sh_size      = swap_uintptr(sct_hdr[i].sh_size);

            sct_hdr[i].sh_link      = swap_uint32(sct_hdr[i].sh_link);
            sct_hdr[i].sh_info      = swap_uint32(sct_hdr[i].sh_info);

            sct_hdr[i].sh_addralign = swap_uintptr(sct_hdr[i].sh_addralign);
            sct_hdr[i].sh_entsize   = swap_uintptr(sct_hdr[i].sh_entsize);
        }
    }

    return sct_hdr;
}