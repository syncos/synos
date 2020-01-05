/* Used to link initIMG */
ENTRY(_start)

SECTIONS
{
    . = 0x0500;
    PROVIDE(__BOOT_HEADER_START = .);
    .boot BLOCK(4) : ALIGN(4)
    {
        *(.multiboot_header)  /* Used if multiboot or multiboot2 is used*/
    }
    PROVIDE(__BOOT_HEADER_END = .);
    . = 0x7C00;
    .init :
    {
        *(.init)
        . = . + 4096;
        *(.init_X86)
    }
    . = 1M;
    PROVIDE(__KERN_MEM_START = .);

    PROVIDE(__KERN_CODE_START = .);
    .text :
    {
        *(.text)
    }
    PROVIDE(__KERN_CODE_END = .);

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
		*(COMMON)
		*(.bss)
	}

    PROVIDE (__KERN_MEM_END = .);
    PROVIDE (__KERN_MEM_SIZE = __KERN_MEM_END - __KERN_MEM_START);
}