#include "x64.h"
#include <mm.h>
#include <stdint.h>

unsigned long          framebuffer_address = 0;
enum framebuffer_types framebuffer_mode;
unsigned int           framebuffer_width;
unsigned int           framebuffer_height;
int arch_print_enabled = 0;

enum vga_color 
{
    BLACK,
    BLUE,
    GREEN,
    CYAN,
    RED,
    MAGENTA,
    BROWN,
    GREY,
    DARK_GREY,
    BRIGHT_BLUE,
    BRIGHT_GREEN,
    BRIGHT_CYAN,
    BRIGHT_RED,
    BRIGHT_MAGENTA,
    YELLOW,
    WHITE,
};
#define TAB_SIZE 4

static uint16_t * display_buffer;
static unsigned int width;
static unsigned int height;
uint8_t fore_color = WHITE, back_color = BLACK;
uint16_t cursor_pos = 0;

static uint16_t CharEntry(unsigned char ch)
{
    uint16_t ax = 0;
    uint8_t ah = back_color, al = ch;

    ah <<= 4;
    ah |= fore_color;
    ax = ah;
    ax <<= 8;
    ax |= al;

    return ax;
}
static inline uint32_t getCursorPosX()
{
    return cursor_pos % width;
}
static inline uint32_t getCursorPosY()
{
    return cursor_pos / width;
}
static void setCursorPos(uint32_t x, uint32_t y)
{
    cursor_pos = y * width + x;

    outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8_t) (cursor_pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8_t) ((cursor_pos >> 8) & 0xFF));
}
static uint16_t getCursorPos()
{
    uint16_t pos = 0;
    outb(0x3D4, 0x0F);
    pos |= inb(0x3D5);
    outb(0x3D4, 0x0E);
    pos |= ((uint16_t)inb(0x3D5)) << 8;
    return pos;
}
static void scroll()
{
    for (uint32_t i = 0; i < height-1; ++i)
        for (uint32_t t = 0; t < width; ++t)
            display_buffer[(i*width)+t] = display_buffer[((i+1)*width)+t];
    for (uint32_t i = 0; i < width; ++i)
        display_buffer[((height-1)*width)+i] = CharEntry(0);
    setCursorPos(getCursorPosX(), getCursorPosY()-1);
}
static void clear_screen()
{
    for (size_t i = 0; i < width * height; ++i)
    {
        display_buffer[i] = CharEntry(0);
    }
    setCursorPos(0, 0);
}

void arch_print(const char* str, size_t length)
{
    if (!arch_print_enabled)
        return;
    for (size_t i = 0; i < length; ++i)
    {
        switch (str[i])
        {
            case ' ' ... '~':
                display_buffer[cursor_pos++] = CharEntry(str[i]);
                break;
            case '\0':
                i = length-1;
                break;
            case '\b':
                if (cursor_pos > 0)
                    --cursor_pos;
                break;
            case '\t':
                cursor_pos += TAB_SIZE - cursor_pos % TAB_SIZE;
                break;
            case '\n':
                setCursorPos(0, getCursorPosY()+1);
                break;
            case '\v':
                setCursorPos(getCursorPosX(), getCursorPosY()+1);
                break;
            case '\f':
                clear_screen();
                break;
            case '\r':
                setCursorPos(0, getCursorPosY());
                break;
            default:
                break;
        }
        scrollRep:
        if (cursor_pos >= width*height) {
            scroll();
            goto scrollRep;
        }
    }

    setCursorPos(getCursorPosX(), getCursorPosY());
}

int framebuffer_init()
{
    if (framebuffer_address == 0 || framebuffer_mode != FRAMEBUFFER_EGA)
        return 0;
    
    display_buffer = kvs_map(framebuffer_address, 2, PAGE_NO_CACHE);
    if (!display_buffer)
        return 0;
    
    width = framebuffer_width;
    height = framebuffer_height;
    cursor_pos = getCursorPos();

    arch_print_enabled = 1;

    return 1;
}