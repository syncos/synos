BITS 64
section .text

global PIC_disable
PIC_disable:
    push rax
    mov al, 0xFF
    out 0xa1, al
    out 0x21, al
    pop rax
    ret