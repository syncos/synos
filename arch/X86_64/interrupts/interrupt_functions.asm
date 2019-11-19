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
; IRQ
global irq_0
irq_0: ; PIT timer
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret

; Exceptions
global int_0
int_0:  ; Divide-by-zero
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_1
int_1:  ; Debug
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_2
int_2:  ; NMI
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_3
int_3:  ; Breakpoint
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_4
int_4:  ; Overflow
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_5
int_5:  ; BRE
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_6
int_6:  ; Invalid Opcode
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_7
int_7:  ; Device not available
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_8
int_8:  ; Double fault
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_9
int_9:  ; CSO
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_10
int_10: ; Invalid TSS
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_11
int_11: ; Segment not present
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_12
int_12: ; Stack segment fault
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_13
int_13: ; General Protection Fault
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_14
int_14: ; Page fault
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_15
int_15: ; Reserved
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_16
int_16: ; x87 FPE
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_17
int_17: ; Alignment check
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_18
int_18: ; Machine check
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_19
int_19: ; SIMD FPE
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_20
int_20: ; Virtualization Exception
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_21_29
int_21_29: ; Reserved
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_30
int_30: ; Security exception
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global int_31
int_31: ; Reserved
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret