ENTRY(_start32)

SECTIONS
{
    . = 1M;
    PROVIDE (__KERNEL_START = .);
    .boot BLOCK(4K) : ALIGN(4)
    {
        *(.multiboot_header)
        *(.multiboot2_header)
    }
    .text BLOCK(4K) : ALIGN(4K)
    {
        PROVIDE (__CODE_START = .);
        *(.text)
        PROVIDE (__CODE_END = .);
    }
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(.bss)
    }
    PROVIDE (__KERNEL_END = .);
}