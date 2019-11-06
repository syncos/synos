/* Used to link initIMG */
ENTRY(_start)

SECTIONS
{
    . = 1M;
    _MemStart = .;

    .boot :
    {
        *(.multiboot_header)
    }
    .text :
    {
        *(.text)
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
		*(COMMON)
		*(.bss)
	}

    _MemEnd = .;
    _MemSize = _MemEnd - 1M;
}