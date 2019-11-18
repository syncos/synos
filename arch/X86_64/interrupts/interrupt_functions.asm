BITS 64
section .text

global interrupt_enabled
interrupt_enabled:
    pushf
    pop rax
    and rax, (1 << 9)
    ret
global interrupt_enable
interrupt_enable:
    push rax
    pushf
    pop rax
    and rax, (1 << 9)
    cmp rax, 0
    je .J0
    pop rax
    ret
.J0:
    sti
    pop rax
    ret
global interrupt_disable
interrupt_disable:
    push rax
    pushf
    pop rax
    and rax, (1 << 9)
    cmp rax, 0
    jne .J0
    pop rax
    ret
.J0:
    cli
    pop rax
    ret