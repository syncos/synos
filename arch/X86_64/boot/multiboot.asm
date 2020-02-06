section .multiboot_header
header_start:
    dd 0x1BADB002 ; MAGIC
    dd 0b111      ; FLAGS
    dd -(0x1BADB002 + 0b111)

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