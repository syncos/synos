section .multiboot_header
header_start:
    dd 0x1BADB002 ; MAGIC
    dd 0b11       ; FLAGS
    dd -(0x1BADB002 + 0b11)

    dd 0
    dd 0
    dd 0
    dd 0
    dd 0

    dd 1
    dd 0
    dd 0
    dd 0
header_end: