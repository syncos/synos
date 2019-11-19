BITS 64
section .text

extern IC_SOI
extern IC_EOI
extern IC_isSpurious

%macro PUSHA 0
    push rax
    push rcx
    push rdx
    push rbx
    push rsp
    push rbp
    push rsi
    push rdi
%endmacro
%macro POPA 0
    pop rdi
    pop rsi
    pop rbp
    pop rsp
    pop rbx
    pop rdx
    pop rcx
    pop rax
%endmacro

irq715_ret:
    call IC_isSpurious
    cmp eax, 1
    je .J0
    call IC_EOI
.J0:
    iret

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

; Syscall
global irq_syscall
irq_syscall:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
; Unused interrupt
; Interrupt functions
irq_0:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_1:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_2:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_3:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_4:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_5:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_6:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_7:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_8:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_9:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_10:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_11:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_12:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_13:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
irq_14:
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret