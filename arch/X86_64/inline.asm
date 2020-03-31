section .text
BITS 64

global halt
halt:
    hlt
    jmp halt

global inb
inb:
    xor rax, rax
    mov dx, di
    in al, dx
    ret
global outb
outb:
    mov dx, di
    mov ax, si
    out dx, al
    ret
global io_wait
io_wait:
    mov dx, 0x80
    xor al, al
    out dx, al
    ret