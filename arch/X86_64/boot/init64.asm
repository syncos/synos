section .init_X86
BITS 64

global _init64
_init64:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    extern init_c
    xor rbp, rbp
    call init_c

    hlt