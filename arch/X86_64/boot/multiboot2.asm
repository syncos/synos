section .multiboot_header
header_start:
    dd 0xE85250D6 ; MAGIC number
    dd 0          ; Architecture 0 (pm i386)
    dd header_end - header_start ; Header length
    dd 0x100000000 - (0xE85250D6 + 0 + (header_end - header_start)) ; Checksum

    ; required end tag
    dw 0    ; type
    dw 0    ; flags
    dd 8    ; size
header_end: