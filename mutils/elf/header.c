#include <elf/elf.h>
#include <synos/arch/cpu.h>
#include <stddef.h>
#include <stdlib.h>

bool FileIsELF(const char* file)
{
    if (file[0] == 0x7F && file[1] == 0x45 && file[2] == 0x4c && file[3] == 0x46) return true;
    return false;
}

uint16_t swap_uint16(uint16_t val) 
{
    return (val << 8) | (val >> 8 );
}
uint32_t swap_uint32(uint32_t val)
{
    val = ((val << 8) & 0xFF00FF00 ) | ((val >> 8) & 0xFF00FF ); 
    return (val << 16) | (val >> 16);
}
uintptr_t swap_uintptr(uintptr_t val)
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

    hdr->header = ((char*)header);
    
    hdr->e_ident = ((char*)header);

    hdr->e_type = &((char*)header)[0x10];
    hdr->e_type_16 = *(uint16_t*)hdr->e_type;

    hdr->e_machine = &((char*)header)[0x12];
    hdr->e_machine_16 = *(uint16_t*)hdr->e_machine;

    hdr->e_version = &((char*)header)[0x14];
    hdr->e_version_32 = *(uint32_t*)hdr->e_version;

    hdr->e_entry = &((char*)header)[0x18];

    int e_flags_start;
    if (hdr->e_ident[EI_CLASS] == 2)
    {
        e_flags_start = 0x30;

        hdr->e_phoff = &((char*)header)[0x20];
        hdr->e_shoff = &((char*)header)[0x28];
    }
    else
    {
        e_flags_start = 0x24;

        hdr->e_phoff = &((char*)header)[0x1C];
        hdr->e_shoff = &((char*)header)[0x20];
    }
    hdr->e_entry_ptr = *(uintptr_t*)hdr->e_entry;
    hdr->e_phoff_ptr = *(uintptr_t*)hdr->e_phoff;
    hdr->e_shoff_ptr = *(uintptr_t*)hdr->e_shoff;

    hdr->e_flags = &((char*)header)[e_flags_start];
    hdr->e_flags_32 = *(uint32_t*)hdr->e_flags;

    hdr->e_ehsize = &((char*)header)[e_flags_start+4];
    hdr->e_ehsize_16 = *(uint16_t*)hdr->e_ehsize;

    hdr->e_phentsize = &((char*)header)[e_flags_start+6];
    hdr->e_phentsize_16  = *(uint16_t*)hdr->e_phentsize;

    hdr->e_phnum = &((char*)header)[e_flags_start+8];
    hdr->e_phnum_16 = *(uint16_t*)hdr->e_phnum;

    hdr->e_shentsize = &((char*)header)[e_flags_start+10];
    hdr->e_shentsize_16 = *(uint16_t*)hdr->e_shentsize;

    hdr->e_shnum = &((char*)header)[e_flags_start+12];
    hdr->e_shnum_16 = *(uint16_t*)hdr->e_shnum;

    hdr->e_shstrndx = &((char*)header)[e_flags_start+14];
    hdr->e_shstrndx_16 = *(uint16_t*)hdr->e_shstrndx;

    if ((isLittleEndian && hdr->e_ident[EI_DATA] == 2) || (isBigEndian && hdr->e_ident[EI_DATA] == 1)) // The elf file is not in the same format as the cpu, what consequences this has for the caller is up to it.
    {
        hdr->e_type_16      = swap_uint16(hdr->e_type_16);
        hdr->e_machine_16   = swap_uint16(hdr->e_machine_16);
        hdr->e_machine_16   = swap_uint16(hdr->e_machine_16);
        hdr->e_version_32   = swap_uint32(hdr->e_version_32);

        hdr->e_entry_ptr    = swap_uintptr(hdr->e_entry_ptr);
        hdr->e_phoff_ptr    = swap_uintptr(hdr->e_phoff_ptr);
        hdr->e_shoff_ptr    = swap_uintptr(hdr->e_phoff_ptr);

        hdr->e_flags_32     = swap_uint32(hdr->e_flags_32);
        hdr->e_ehsize_16    = swap_uint16(hdr->e_ehsize_16);
        hdr->e_phentsize_16 = swap_uint16(hdr->e_phentsize_16);
        hdr->e_phnum_16     = swap_uint16(hdr->e_phnum_16);
        hdr->e_shentsize_16 = swap_uint16(hdr->e_shentsize_16);
        hdr->e_shnum_16     = swap_uint16(hdr->e_shnum_16);
        hdr->e_shstrndx_16  = swap_uint16(hdr->e_shstrndx_16);
    }

    return hdr;
}

struct ELF_PROGRAM_HEADER* ParseELF_PRG_HEADER(const struct ELF_HEADER* hdr, char* prg_hdr_start)
{
    struct ELF_PROGRAM_HEADER* prg_hdr = (struct ELF_PROGRAM_HEADER*)kmalloc(sizeof(struct ELF_PROGRAM_HEADER) * hdr->e_phnum_16);

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

    for (uint16_t i = 0; i < hdr->e_phnum_16; i++)
    {
        char* hdr_ent = prg_hdr_start + hdr_ent_size*i;

        prg_hdr[i].header = hdr_ent;
        prg_hdr[i].header_length = hdr_ent_size;

        prg_hdr[i].p_type = *(uint32_t*)hdr_ent;

        prg_hdr[i].p_offset = &hdr_ent[p_offset_offset];
        if (hdr->e_ident[EI_CLASS] == 2) 
        {
            prg_hdr[i].p_vaddr  = &hdr_ent[0x10];
            prg_hdr[i].p_paddr  = &hdr_ent[0x18];
            prg_hdr[i].p_filesz = &hdr_ent[0x20];
            prg_hdr[i].p_memsz  = &hdr_ent[0x28];
            prg_hdr[i].p_align  = &hdr_ent[0x30];

            prg_hdr[i].p_flags = *(uint32_t*)&hdr_ent[0x04];
        }
        else  
        {
            prg_hdr[i].p_vaddr  = &hdr_ent[0x08];
            prg_hdr[i].p_paddr  = &hdr_ent[0x0C];
            prg_hdr[i].p_filesz = &hdr_ent[0x10];
            prg_hdr[i].p_memsz  = &hdr_ent[0x14];
            prg_hdr[i].p_align  = &hdr_ent[0x1C];

            prg_hdr[i].p_flags = *(uint32_t*)&hdr_ent[0x18];
        }
        prg_hdr[i].p_offset_ptr = *(uintptr_t*)prg_hdr[i].p_offset;
        prg_hdr[i].p_vaddr_ptr  = *(uintptr_t*)prg_hdr[i].p_vaddr;
        prg_hdr[i].p_paddr_ptr  = *(uintptr_t*)prg_hdr[i].p_paddr;
        prg_hdr[i].p_filesz_ptr = *(uintptr_t*)prg_hdr[i].p_filesz;
        prg_hdr[i].p_memsz_ptr  = *(uintptr_t*)prg_hdr[i].p_memsz;
        prg_hdr[i].p_align_ptr  = *(uintptr_t*)prg_hdr[i].p_align;

        if ((isLittleEndian && hdr->e_ident[EI_DATA] == 2) || (isBigEndian && hdr->e_ident[EI_DATA] == 1)) // Endian mismatch
        {
            prg_hdr[i].p_type       = swap_uint32(prg_hdr[i].p_type);
            prg_hdr[i].p_flags      = swap_uint32(prg_hdr[i].p_flags);

            prg_hdr[i].p_offset_ptr = swap_uintptr(prg_hdr[i].p_offset_ptr);
            prg_hdr[i].p_vaddr_ptr  = swap_uintptr(prg_hdr[i].p_vaddr_ptr);
            prg_hdr[i].p_paddr_ptr  = swap_uintptr(prg_hdr[i].p_paddr_ptr);
            prg_hdr[i].p_filesz_ptr = swap_uintptr(prg_hdr[i].p_filesz_ptr);
            prg_hdr[i].p_memsz_ptr  = swap_uintptr(prg_hdr[i].p_memsz_ptr);
            prg_hdr[i].p_align_ptr  = swap_uintptr(prg_hdr[i].p_align_ptr);
        }
    }

    return prg_hdr;
}