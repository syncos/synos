BITS 64
section .text

extern IC_SOI
extern IC_EOI

%macro SOI 1
    push rdi
    mov rdi, %1
    call IC_SOI
    pop rdi
%endmacro
%macro EOI 1
    push rdi
    mov rdi, %1
    call IC_EOI 
    pop rdi
%endmacro

global interrupt_enable
interrupt_enable:
    sti
    ret
global interrupt_disable
interrupt_disable:
    cli
    ret

global IDT_load
IDT_load:
    cli
    lidt [rdi]
    ret
; global idt_set
; ; void idt_set(struct IDT_Entry *entry, void* address, uint8_t attrib)
; idt_set:
;     mov rax, rsi
;     mov word [rdi], ax
;     mov word [rdi+2], cs
;     mov byte [rdi+4], 0
;     mov byte [rdi+5], dl
;     shr rax, 16
;     mov word [rdi+6], ax
;     shr rax, 16
;     mov dword [rdi+8], eax
;     xor eax, eax
;     mov dword [rdi+12], eax
;     ret

global syscall_fn
syscall_fn:
    iretq

global exc_0
exc_0:
    iretq
global exc_1
exc_1:
    iretq
global exc_2
exc_2:
    iretq
global exc_3
exc_3:
    iretq
global exc_4
exc_4:
    iretq
global exc_5
exc_5:
    iretq
global exc_6
exc_6:
    iretq
global exc_7
exc_7:
    iretq
global exc_8
exc_8:
    iretq
global exc_9
exc_9:
    iretq
global exc_10
exc_10:
    iretq
global exc_11
exc_11:
    iretq
global exc_12
exc_12:
    iretq
global exc_13
exc_13:
    iretq
global exc_14
exc_14:
    iretq
global exc_16
exc_16:
    iretq
global exc_17
exc_17:
    iretq
global exc_18
exc_18:
    iretq
global exc_19
exc_19:
    iretq
global exc_20
exc_20:
    iretq
global exc_30
exc_30:
    iretq

global irq_0
irq_0:
    SOI 0
    EOI 0
    iretq
global irq_1
irq_1:
    SOI 1
    EOI 1
    iretq
global irq_2
irq_2:
    SOI 2
    EOI 2
    iretq
global irq_3
irq_3:
    SOI 3
    EOI 3
    iretq
global irq_4
irq_4:
    SOI 4
    EOI 4
    iretq
global irq_5
irq_5:
    SOI 5
    EOI 5
    iretq
global irq_6
irq_6:
    SOI 6
    EOI 6
    iretq
global irq_7
irq_7:
    SOI 7
    EOI 7
    iretq
global irq_8
irq_8:
    SOI 8
    EOI 8
    iretq
global irq_9
irq_9:
    SOI 9
    EOI 9
    iretq
global irq_10
irq_10:
    SOI 10
    EOI 10
    iretq
global irq_11
irq_11:
    SOI 11
    EOI 11
    iretq
global irq_12
irq_12:
    SOI 12
    EOI 12
    iretq
global irq_13
irq_13:
    SOI 13
    EOI 13
    iretq
global irq_14
irq_14:
    SOI 14
    EOI 14
    iretq
global irq_15
irq_15:
    SOI 15
    EOI 15
    iretq