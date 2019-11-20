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

global IDT_load
IDT_load:
    lidt [rdi]
    ret

irq715_ret:
    call IC_isSpurious
    cmp eax, 1
    je .J0
    
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
global int_unused
int_unused:
    PUSHA

    POPA
    iret
; Interrupt functions
; IRQ
global irq_0
irq_0: ; PIT timer
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_1
irq_1: ; Keyboard interrupt
    PUSHA
    call IC_SOI
    

    call IC_EOI
    POPA
    iret
global irq_2
irq_2: ; Cascade
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_3
irq_3: ; COM2
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_4
irq_4: ; COM1
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_5
irq_5: ; LPT2
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_6
irq_6: ; Floppy
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_7
irq_7: ; LPT1 / Spurious (if pic)
    PUSHA
    call IC_SOI
    call IC_isSpurious
    cmp eax, 1
    je .J0


    call IC_EOI
    POPA
    iret
.J0:
    POPA
    iret
global irq_8
irq_8: ; CMOS clock
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_9
irq_9: ; Free
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_10
irq_10: ; Free
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_11
irq_11: ; Free
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_12
irq_12: ; PS2 Mouse
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_13
irq_13: ; FPU
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_14
irq_14: ; Primary ATA
    PUSHA
    call IC_SOI

    call IC_EOI
    POPA
    iret
global irq_15
irq_15: ; Secondary ATA / Spurious
    PUSHA
    call IC_SOI
    call IC_isSpurious
    cmp eax, 1
    je .J0


    call IC_EOI
    POPA
    iret
.J0:
    mov al, 0x20
    out 0x20, al ; EOI PIC master
    POPA
    iret

; Exceptions
global int_0
int_0:  ; Divide-by-zero
    PUSHA

    
    POPA
    iret
global int_1
int_1:  ; Debug
    PUSHA
    

    
    POPA
    iret
global int_2
int_2:  ; NMI
    PUSHA
    

    
    POPA
    iret
global int_3
int_3:  ; Breakpoint
    PUSHA
    

    
    POPA
    iret
global int_4
int_4:  ; Overflow
    PUSHA
    

    
    POPA
    iret
global int_5
int_5:  ; BRE
    PUSHA
    

    
    POPA
    iret
global int_6
int_6:  ; Invalid Opcode
    PUSHA
    

    
    POPA
    iret
global int_7
int_7:  ; Device not available
    PUSHA
    

    
    POPA
    iret
global int_8
int_8:  ; Double fault
    PUSHA
    

    
    POPA
    iret
global int_9
int_9:  ; CSO
    PUSHA
    

    
    POPA
    iret
global int_10
int_10: ; Invalid TSS
    PUSHA
    

    
    POPA
    iret
global int_11
int_11: ; Segment not present
    PUSHA
    

    
    POPA
    iret
global int_12
int_12: ; Stack segment fault
    PUSHA
    

    
    POPA
    iret
global int_13
int_13: ; General Protection Fault
    PUSHA
    

    
    POPA
    iret
global int_14
int_14: ; Page fault
    PUSHA
    

    
    POPA
    iret
global int_15
int_15: ; Reserved
    PUSHA
    

    
    POPA
    iret
global int_16
int_16: ; x87 FPE
    PUSHA
    

    
    POPA
    iret
global int_17
int_17: ; Alignment check
    PUSHA
    

    
    POPA
    iret
global int_18
int_18: ; Machine check
    PUSHA
    

    
    POPA
    iret
global int_19
int_19: ; SIMD FPE
    PUSHA
    

    
    POPA
    iret
global int_20
int_20: ; Virtualization Exception
    PUSHA
    

    
    POPA
    iret
global int_21_29
int_21_29: ; Reserved
    PUSHA
    

    
    POPA
    iret
global int_30
int_30: ; Security exception
    PUSHA
    

    
    POPA
    iret
global int_31
int_31: ; Reserved
    PUSHA
    

    
    POPA
    iret