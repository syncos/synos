#include <inttypes.h>
#include <mkos/arch/arch.h>
#include <mkos/arch/multiboot2.h>

bool mboot2Init(uint32_t addr, uint32_t magic, boot_t* mb2Data)
{
    struct multiboot_tag *tag;

    if (magic != MULTIBOOT2_BOOTLOADER_MAGIC) return false;

    for (tag = (struct multiboot_tag *)(uint64_t)(addr + 8); tag->type != MULTIBOOT_TAG_TYPE_END; tag = (struct multiboot_tag *) ((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7)))
    {
        switch (tag->type)
        {
            case MULTIBOOT_TAG_TYPE_CMDLINE:
                mb2Data->BCL.enabled = true;
                mb2Data->BCL.string = ((struct multiboot_tag_string *)tag)->string;
                break;
            case MULTIBOOT_TAG_TYPE_BOOT_LOADER_NAME:
                break;
            case MULTIBOOT_TAG_TYPE_MODULE:
                mb2Data->MDS.enabled = true;
                mb2Data->MDS.mod_start = ((struct multiboot_tag_module *) tag)->mod_start;
                mb2Data->MDS.mod_end = ((struct multiboot_tag_module *) tag)->mod_end;
                mb2Data->MDS.string = ((struct multiboot_tag_module *) tag)->cmdline;
                break;
            case MULTIBOOT_TAG_TYPE_BASIC_MEMINFO:
                mb2Data->bmi.enabled = true;
                mb2Data->bmi.lower = ((struct multiboot_tag_basic_meminfo *) tag)->mem_lower;
                mb2Data->bmi.upper = ((struct multiboot_tag_basic_meminfo *) tag)->mem_upper;
                break;
            case MULTIBOOT_TAG_TYPE_BOOTDEV:
                mb2Data->BBd.enabled = true;
                mb2Data->BBd.biosdev = ((struct multiboot_tag_bootdev *) tag)->biosdev;
                mb2Data->BBd.partition = ((struct multiboot_tag_bootdev *) tag)->part;
                mb2Data->BBd.sub_partition = ((struct multiboot_tag_bootdev *) tag)->slice;
                break;
            case MULTIBOOT_TAG_TYPE_MMAP:
                mb2Data->MM.enabled = true;
                mb2Data->MM.nEntries = 0;
                multiboot_memory_map_t *mmap;
                for (mmap = ((struct multiboot_tag_mmap *) tag)->entries; (multiboot_uint8_t *) mmap < (multiboot_uint8_t *) tag + tag->size; mmap = (multiboot_memory_map_t *)((unsigned long) mmap + ((struct multiboot_tag_mmap *) tag)->entry_size))
                {
                    mb2Data->MM.nEntries++;
                }
                mb2Data->MM.mem_entries = (MM_entries_t*)memstck_malloc(sizeof(MM_entries_t)*mb2Data->MM.nEntries);
                uint64_t i = 0;
                for (mmap = ((struct multiboot_tag_mmap *) tag)->entries; (multiboot_uint8_t *) mmap < (multiboot_uint8_t *) tag + tag->size; mmap = (multiboot_memory_map_t *)((unsigned long) mmap + ((struct multiboot_tag_mmap *) tag)->entry_size))
                {
                    mb2Data->MM.mem_entries[i].enabled = true;
                    mb2Data->MM.mem_entries[i].base_addr = (unsigned)mmap->addr;
                    mb2Data->MM.mem_entries[i].length = (unsigned)mmap->len;
                    mb2Data->MM.mem_entries[i].type = (unsigned) mmap->type;

                    i++;
                }
                break;
        }
    }
    return true;
}