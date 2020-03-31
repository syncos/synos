#ifndef X64_H
#define X64_H

#define KERNEL_START 0x100000
#define KERNEL_MAX_SIZE 0x200000

enum kerror_codes
{
    KERR_OK,
    KERR_NOCPUID,
    KERR_NOLONGMD,
    KERR_NOTMULTIBOOT,
    KERR_KVIRTSPACE,
    KERR_KMREGION,
    KERR_MULTIBOOT_MAP,
    KERR_KSLAB,
    KERR_MULTIBOOT_INIT,
    KERR_NOMEM,
};
enum boot_mode
{
    MULTIBOOT,
    MULTIBOOT2,
};
enum framebuffer_types
{
    FRAMEBUFFER_PIXELS,
    FRAMEBUFFER_EGA,
};

extern enum boot_mode boot_loader;

extern void   kernel_AS();

extern void halt();
extern char * kerror_string;
extern unsigned int kerror;

static inline void EHALT(enum kerror_codes errno, char * str)
{
    kerror = errno;
    kerror_string = str;
    halt();
}

extern unsigned int mbm;
extern unsigned int mbp;

extern unsigned long          framebuffer_address;
extern enum framebuffer_types framebuffer_mode;
extern unsigned int           framebuffer_width;
extern unsigned int           framebuffer_height;

int framebuffer_init();

unsigned char inb (unsigned short port);
void          outb(unsigned short port, unsigned char value);

#endif