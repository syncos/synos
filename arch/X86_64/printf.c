#include <stdint.h>
#ifdef PRINTF_FALLBACK
// Fallback stdio functions
// If the system has working out-of-the-box vga support, this option should be enabled. Otherwise, the system logs and printf string 
// will be stored and printed once full display support is initialized (after main kernel boot up).
// It is recommended to debug on a system which has support for this.
#include <synos/arch/arch.h>
#include <synos/arch/io.h>
#include <synos/log.h>
#include <string.h>

#define VGA_ADDRESS_D 0xB8000
#define BUFFER_SIZE_D 2200

#define VGA_WIDTH_D 80
#define VGA_HEIGHT_D 24
#define SCANLINE_LOW_D 0
#define SCANLINE_HIGH_D 1

const bool PRINTF_FB_ENABLE = true;
struct PRINTF_FUNC printf_fallback_fn;

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

uint8_t fore_color = WHITE, back_color = BLACK;
uint16_t* display_buffer = (uint16_t*)VGA_ADDRESS_D;
uint16_t cursor_pos = 0;
bool cursor_enable = true;
bool hasInit = false;

uint16_t _CharEntry(unsigned char ch)
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
void _setCursorPos(uint32_t x, uint32_t y)
{
    cursor_pos = y * VGA_WIDTH_D + x;

    outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8_t) (cursor_pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8_t) ((cursor_pos >> 8) & 0xFF));
}
uint32_t _getCursorPosX()
{
    return cursor_pos % VGA_WIDTH_D;
}
uint32_t _getCursorPosY()
{
    return cursor_pos / VGA_WIDTH_D;
}
void _clearScreen()
{
    for(uint32_t i = 0; i < VGA_WIDTH_D * VGA_HEIGHT_D; i++)
    {
        display_buffer[i] = _CharEntry(0);
    }
    _setCursorPos(0, 0);
}
void _scrollStep()
{
    //TODO: finish this function (and the user version)
    for(int i = 1; i < VGA_HEIGHT_D; i++)
    {
      for(int t = 0; t < VGA_WIDTH_D; t++)
      {
        display_buffer[i*VGA_WIDTH_D + t] = display_buffer[(i - 1)*VGA_WIDTH_D + t];
      }
    }
    _setCursorPos(_getCursorPosX(), _getCursorPosY() - 1);
}

int arch_printf(const char* restrict text)
{
    size_t length = strlen(text);

    size_t i;
    for(i = 0; i < length; i++)
    {
        switch (text[i])
        {
            case 0xA:
                _setCursorPos(0, _getCursorPosY() + 1);
                break;
            default:
                display_buffer[cursor_pos] = _CharEntry(text[i]);
                cursor_pos++;
                break;
        }
    }
    if(cursor_pos == 1920) _scrollStep();

    uint32_t y = cursor_pos / VGA_WIDTH_D;
    uint32_t x = cursor_pos % VGA_WIDTH_D;
    _setCursorPos(x, y);

    scrollPoint:
    if(cursor_pos == 1920)
    {
      _scrollStep();
      goto scrollPoint;
    }

    return 1;
}

struct PRINTF_FUNC* printf_init()
{
    pr_log(INFO, "Initializing built in x86 printf using vga textmode...");
    if (!PRINTF_FB_ENABLE) return 0;
    if(!hasInit)
    {
        hasInit = true;
        _clearScreen();
    }

    printf_fallback_fn.enabled = true;
    printf_fallback_fn.printf = arch_printf;
    
    return &printf_fallback_fn;
}
#else
const bool PRINTF_FB_ENABLE = false;
#endif