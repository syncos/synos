#include <synos.h>
#include <arch.h>
#include <mm.h>
#include <slab.h>
#include <arch/memory.h>
#include "x64.h"
#include "cpu.h"
#include "acpi.h"
#include "interrupts.h"
#include "multiboot.h"
#include "multiboot2.h"
#include <stdint.h>
#include <string.h>
#include <arch/print.h>

enum boot_mode boot_loader;
char * kerror_string = NULL;
uint32_t
 kerror = 0;
const enum ARCH arch = X86_64;
m_region_t * p_mem_regions = NULL;
unsigned long p_mem_regions_length = 0;
unsigned long p_mem_totalsize = 0;

char kpageent[131];

m_region_t kmemr = {
    .start = KERNEL_START,
    .size = KERNEL_MAX_SIZE,
    .flags = M_REGION_USABLE | M_REGION_READ | M_REGION_WRITE,

    .pages_total = 512,
    .pages_free = 0, // Will be set later by mregion_init

    .next = NULL,

    .lock = 0,
};
m_region_t * mregions = &kmemr;

static void mem_protect()
{
    if (MAX_ORDER < 8) {
        unsigned long offset = 0;
        unsigned long pcount = 0x100000 / page_size;
        while (pcount) {
            unsigned int orq = pages_to_order(pcount);
            if (orq > MAX_ORDER)
                orq = MAX_ORDER;
            ppages_reserve(offset, orq);
            pcount -= ORDER(orq);
            offset += ORDER(orq) * page_size;
        }
    }
    else {
        ppages_reserve(0, 8);
    }
}
static void multiboot_init(unsigned long mbp)
{
    multiboot_info_t * mbi_s = kvs_map(mbp, 0, 0);
    if (!mbi_s) {
        EHALT(KERR_MULTIBOOT_MAP, "Unable to map original multiboot data to kvs");
    }
    multiboot_info_t * mbi = kmalloc(sizeof(multiboot_info_t), GFP_KERNEL);
    if (!mbi) {
        EHALT(KERR_NOMEM, "");
    }
    memcpy(mbi, mbi_s, sizeof(multiboot_info_t));
    kvs_unmap(mbi_s, 0);

    if (!(mbi->flags & MULTIBOOT_INFO_MEM_MAP))
        EHALT(KERR_MULTIBOOT_INIT, "No memory map provided");
    unsigned long mmap_diff = mbi->mmap_addr - (mbi->mmap_addr & ~(0xFFFUL));
    unsigned int mmap_order = pages_to_order((mbi->mmap_length + mmap_diff + (page_size-1)) / page_size);
    multiboot_memory_map_t * mmap_i = kvs_map(mbi->mmap_addr & ~(0xFFFUL), mmap_order, 0);
    if (!mmap_i) {
        EHALT(KERR_MULTIBOOT_MAP, "Unable to map mmap");
    }
    mmap_i = (void*)((unsigned long)mmap_i + mmap_diff);
    multiboot_memory_map_t * mmap = kmalloc(mbi->mmap_length, GFP_KERNEL);
    if (!mmap) {
        EHALT(KERR_NOMEM, "");
    }
    memcpy(mmap, mmap_i, mbi->mmap_length);
    kvs_unmap((void*)((unsigned long)mmap_i - mmap_diff), mmap_order);
    unsigned long mmap_start = (unsigned long)mmap;
    for (;
        (unsigned long)mmap < mmap_start + mbi->mmap_length;
        mmap = (multiboot_memory_map_t*)((unsigned long)mmap + mmap->size + sizeof(mmap->size))
        ) {
        
        unsigned long pages = mmap->len / page_size;
        if (pages < 16)
            continue;

        m_region_t * nr = kmalloc(sizeof(m_region_t), GFP_KERNEL);
        if (!nr)
            EHALT(KERR_NOMEM, "No memory for new memory region");
        
        nr->start = mmap->addr;
        nr->size = mmap->len;
        
        switch (mmap->type)
        {
        case MULTIBOOT_MEMORY_AVAILABLE:
            nr->flags = M_REGION_USABLE | M_REGION_READ | M_REGION_WRITE;
            break;
        case MULTIBOOT_MEMORY_RESERVED:
            nr->flags = M_REGION_RESERVED;
            break;
        case MULTIBOOT_MEMORY_ACPI_RECLAIMABLE:
            nr->flags = M_REGION_MMAPPED | M_REGION_PROTECTED | M_REGION_READ | M_REGION_WRITE;
            break;
        case MULTIBOOT_MEMORY_NVS:
            nr->flags = M_REGION_PROTECTED;
            break;
        default:
            nr->flags = M_REGION_BAD;
            break;
        }
        nr->pages_total = pages;
        nr->next = NULL;
        nr->lock = 0;

        if (p_mem_regions == NULL) {
            p_mem_regions = kmalloc(sizeof(m_region_t), GFP_KERNEL);
            if (!p_mem_regions)
                EHALT(KERR_NOMEM, "");
            memcpy(p_mem_regions, nr, sizeof(m_region_t));
        }
        else {
            m_region_t * lr;
            for (lr = p_mem_regions; lr->next != NULL; lr = lr->next) {}
            lr->next = kmalloc(sizeof(m_region_t), GFP_KERNEL);
            if (!lr->next)
                EHALT(KERR_NOMEM, "");
            memcpy(lr->next, nr, sizeof(m_region_t));
        }
        ++p_mem_regions_length;
        p_mem_totalsize += nr->size;

        if (!(nr->flags & M_REGION_USABLE)) {
            kfree(nr);
            continue;
        }
        if (KERNEL_START >= nr->start && KERNEL_START < nr->start + nr->size) {
            if (KERNEL_START + KERNEL_MAX_SIZE == nr->start + nr->size) {
                nr->size -= KERNEL_MAX_SIZE;
                pages = nr->size / page_size;
                goto s_done;
            }
            if (KERNEL_START == nr->start) {
                nr->start += KERNEL_MAX_SIZE;
                nr->size -= KERNEL_MAX_SIZE;
                pages = nr->size / page_size;
                goto s_done;
            }
            m_region_t * lf = kmalloc(sizeof(m_region_t), GFP_KERNEL);
            if (!lf)
                EHALT(KERR_NOMEM, "No memory for new memory region");
            lf->start = KERNEL_START + KERNEL_MAX_SIZE;
            lf->size = (nr->start + nr->size) - lf->start;
            lf->flags = nr->flags;
            lf->pages_total = lf->size / page_size;
            lf->lock = 0;
            unsigned long pageent_size = pageent_len(lf->pages_total);
            void * pageent = kmalloc(pageent_size, GFP_KERNEL);
            if (!pageent)
                EHALT(KERR_NOMEM, "Unable to allocate memory for pageent");

            nr->size = KERNEL_START - nr->start;
            pages = nr->size / page_size;

            mregions_insert(lf);
            if (!mregion_init(lf, pageent)) {
                mregions_remove(lf);
                kfree(lf);
                kfree(pageent);
            }
            goto s_done;
        }
        s_done:
        if (pages < 16)
            continue;

        nr->pages_total = pages;

        unsigned long pageent_size = pageent_len(pages);
        void * pageent = kmalloc(pageent_size, GFP_KERNEL);
        if (!pageent)
            EHALT(KERR_NOMEM, "Unable to allocate memory for pageent");
        
        mregions_insert(nr);
        if (!mregion_init(nr, pageent)) {
            kfree(nr);
            kfree(pageent);
            continue;
        }
        mem_protect();
    }
    kfree((void*)mmap_start);

    if (mbi->flags & MULTIBOOT_INFO_FRAMEBUFFER_INFO) {
        framebuffer_address = mbi->framebuffer_addr;
        framebuffer_width = mbi->framebuffer_width;
        framebuffer_height = mbi->framebuffer_height;
        if (mbi->framebuffer_type == 2)
            framebuffer_mode = FRAMEBUFFER_EGA;
        else
            framebuffer_mode = FRAMEBUFFER_PIXELS;
    }

    kfree(mbi);
}
static void multiboot2_init(unsigned long mbp)
{
    unsigned long mbp_diff = mbp - (mbp & ~(0xFFFUL));
    multiboot2_uint32_t * total_size_p = kvs_map(mbp, 0, 0);
    if (!total_size_p) {
        EHALT(KERR_MULTIBOOT_MAP, "Unable to map original multiboot data to kvs");
    }
    multiboot2_uint32_t total_size = *((multiboot2_uint32_t *)((unsigned long)total_size_p + mbp_diff));
    kvs_unmap(total_size_p, 0);

    unsigned int morder = pages_to_order((total_size + (page_size-1)) / page_size);
    void * mb2data_org = kvs_map(mbp, morder, 0);
    if (!mb2data_org) {
        EHALT(KERR_MULTIBOOT_MAP, "Unable to map original multiboot data to kvs");
    }
    void * mb2data = kmalloc(total_size, GFP_KERNEL);
    if (!mb2data) {
        EHALT(KERR_NOMEM, "");
    }
    memcpy(mb2data, (void*)((unsigned long)mb2data_org + mbp_diff), total_size);
    kvs_unmap(mb2data_org, morder);

    for (   struct multiboot2_tag * tag = (void*)((unsigned long)mb2data + sizeof(multiboot2_uint32_t)*2);
            tag->type != MULTIBOOT2_TAG_TYPE_END;
            tag = (struct multiboot2_tag *) ((multiboot2_uint8_t *) tag + ((tag->size + 7) & ~7))) {
        
        switch (tag->type)
        {
        case MULTIBOOT2_TAG_TYPE_FRAMEBUFFER:;
            struct multiboot2_tag_framebuffer_common * fb = (struct multiboot2_tag_framebuffer_common *)tag;
            framebuffer_address = fb->framebuffer_addr;
            framebuffer_width = fb->framebuffer_width;
            framebuffer_height = fb->framebuffer_height;
            if (fb->framebuffer_type == 2)
                framebuffer_mode = FRAMEBUFFER_EGA;
            else
                framebuffer_mode = FRAMEBUFFER_PIXELS;
            break;
        case MULTIBOOT2_TAG_TYPE_MMAP:
            for (   multiboot2_memory_map_t * mmap = ((struct multiboot2_tag_mmap *)tag)->entries;
                    (unsigned long)mmap < (unsigned long)tag + tag->size;
                    mmap = (void*)((unsigned long)mmap + ((struct multiboot2_tag_mmap *)tag)->entry_size)) {
                
                unsigned long pages = mmap->len / page_size;
                if (pages < 16)
                    continue;

                m_region_t * nr = kmalloc(sizeof(m_region_t), GFP_KERNEL);
                if (!nr)
                    EHALT(KERR_NOMEM, "No memory for new memory region");
        
                nr->start = mmap->addr;
                nr->size = mmap->len;

                switch (mmap->type)
                {
                case MULTIBOOT2_MEMORY_AVAILABLE:
                    nr->flags = M_REGION_USABLE | M_REGION_READ | M_REGION_WRITE;
                    break;
                case MULTIBOOT2_MEMORY_RESERVED:
                    nr->flags = M_REGION_RESERVED;
                    break;
                case MULTIBOOT2_MEMORY_ACPI_RECLAIMABLE:
                    nr->flags = M_REGION_MMAPPED | M_REGION_PROTECTED | M_REGION_READ | M_REGION_WRITE;
                    break;
                case MULTIBOOT2_MEMORY_NVS:
                    nr->flags = M_REGION_PROTECTED;
                    break;
                default:
                    nr->flags = M_REGION_BAD;
                    break;
                }

                nr->pages_total = pages;
                nr->next = NULL;
                nr->lock = 0;

                if (p_mem_regions == NULL) {
                    p_mem_regions = kmalloc(sizeof(m_region_t), GFP_KERNEL);
                    if (!p_mem_regions)
                        EHALT(KERR_NOMEM, "");
                    memcpy(p_mem_regions, nr, sizeof(m_region_t));
                }
                else {
                    m_region_t * lr;
                    for (lr = p_mem_regions; lr->next != NULL; lr = lr->next) {}
                    lr->next = kmalloc(sizeof(m_region_t), GFP_KERNEL);
                    if (!lr->next)
                        EHALT(KERR_NOMEM, "");
                    memcpy(lr->next, nr, sizeof(m_region_t));
                }
                ++p_mem_regions_length;
                p_mem_totalsize += nr->size;

                if (!(nr->flags & M_REGION_USABLE)) {
                    kfree(nr);
                    continue;
                }
                if (KERNEL_START >= nr->start && KERNEL_START < nr->start + nr->size) {
                    if (KERNEL_START + KERNEL_MAX_SIZE == nr->start + nr->size) {
                        nr->size -= KERNEL_MAX_SIZE;
                        pages = nr->size / page_size;
                        goto s_done;
                    }
                    if (KERNEL_START == nr->start) {
                        nr->start += KERNEL_MAX_SIZE;
                        nr->size -= KERNEL_MAX_SIZE;
                        pages = nr->size / page_size;
                        goto s_done;
                    }
                    m_region_t * lf = kmalloc(sizeof(m_region_t), GFP_KERNEL);
                    if (!lf)
                        EHALT(KERR_NOMEM, "No memory for new memory region");
                    lf->start = KERNEL_START + KERNEL_MAX_SIZE;
                    lf->size = (nr->start + nr->size) - lf->start;
                    lf->flags = nr->flags;
                    lf->pages_total = lf->size / page_size;
                    lf->lock = 0;
                    unsigned long pageent_size = pageent_len(lf->pages_total);
                    void * pageent = kmalloc(pageent_size, GFP_KERNEL);
                    if (!pageent)
                        EHALT(KERR_NOMEM, "Unable to allocate memory for pageent");

                    nr->size = KERNEL_START - nr->start;
                    pages = nr->size / page_size;

                    mregions_insert(lf);
                    if (!mregion_init(lf, pageent)) {
                        mregions_remove(lf);
                        kfree(lf);
                        kfree(pageent);
                    }
                    goto s_done;
                }
                s_done:
                if (pages < 16)
                    continue;

                nr->pages_total = pages;

                unsigned long pageent_size = pageent_len(pages);
                void * pageent = kmalloc(pageent_size, GFP_KERNEL);
                if (!pageent)
                    EHALT(KERR_NOMEM, "Unable to allocate memory for pageent");
        
                mregions_insert(nr);
                if (!mregion_init(nr, pageent)) {
                    kfree(nr);
                    kfree(pageent);
                    continue;
                }
                mem_protect();
            }
            break;
        }
    }

    kfree(mb2data);
}

void c_entry()
{
    switch (mbm)
    {
    case MULTIBOOT_BOOTLOADER_MAGIC:
        boot_loader = MULTIBOOT;
        break;
    case MULTIBOOT2_BOOTLOADER_MAGIC:
        boot_loader = MULTIBOOT2;
        break;extern m_region_t * mregions;
    }
    // Initialize the 2 MB memory window
    if (!mregion_init(&kmemr, &kpageent)) {
        EHALT(KERR_KMREGION, "Unable to initialize kernel memory region");
    }
    // Reserve all memory pages used initially by the kernel
    unsigned long kernel_pages = (KERNEL_END - KERNEL_START + (page_size-1)) / page_size;
    mregion_reserve(&kmemr, KERNEL_START, pages_to_order(kernel_pages));

    // Initialize the kernel virtual address space
    if (!kvs_init()) {
        EHALT(KERR_KVIRTSPACE, "Unable to initialize kernel virtual address space");
    }

    // Initalize slab
    if (!kslab_init()) {
        EHALT(KERR_KSLAB, "Unable to initalize kernel slab allocator");
    }

    switch (boot_loader) 
    {
    case MULTIBOOT:
        multiboot_init(mbp);
        break;
    case MULTIBOOT2:
        multiboot2_init(mbp);
        break;
    }

    framebuffer_init();
    printk_init();

    printk(INFO, "Logging system with EGA textmode initalized");
    printk(DEBUG, "Text dimentions: %u x %u", framebuffer_width, framebuffer_height);
    printk(INFO, "Memory map: detected %u regions, %u KiB total", p_mem_regions_length, p_mem_totalsize / 1024);
    unsigned int i = 0;
    for (m_region_t * c = p_mem_regions; c != NULL; c = c->next) {
        printk(DEBUG, "\tMemory area %u: 0x%X\t-\t0x%X, %u KiB", i, c->start, c->start + c->size - 1, c->size / 1024);
        ++i;
    }
    printk(DEBUG, "%u KiB used - %u KiB free", ((pages_total - pages_free)*page_size) / 1024, (pages_free*page_size) / 1024);

    cpuinfo();

    idt_init();

    acpi_init();
}