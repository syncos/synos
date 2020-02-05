#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/arch.h>
#include <synos/arch/io.h>
#include "x64.h"

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

uint16_t* display_buffer;
uint32_t width;
uint32_t height;

uint8_t fore_color = WHITE, back_color = BLACK;
uint16_t cursor_pos = 0;
bool cursor_enable = true;

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
static void scroll()
{
    for (int64_t line = height-2; line >= 0; --line)
        for (uint32_t p = 0; p < width; ++p)
            display_buffer[(line*width)+p] = display_buffer[((line-1)*width)+p];
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
                cursor_pos += TAB_SIZE;
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
        if (cursor_pos > width*height) {
            scroll();
            goto scrollRep;
        }
    }

    setCursorPos(getCursorPosX(), getCursorPosY());
}

int arch_printk_init()
{
    if (X64.framebuffer.type != EGA_TEXT) {
        return -1;
    }

    display_buffer = vpages_map(X64.framebuffer.address, 2, VPAGE_NO_EXECUTE | VPAGE_NO_CACHE);
    width = X64.framebuffer.width;
    height = X64.framebuffer.height;

    clear_screen();

    return 0;
}