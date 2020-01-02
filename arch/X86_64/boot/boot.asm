section .text
global _start64
BITS 64

_start64:
    ; Set all segment registers to 0
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    extern startup
    xor rbp, rbp ; Set rbp to null to make stack tracing work
    call startup ; Call kernel

    hlt ; Parachute just in case if the main kernel function for some reason returns which it should not