section .init
BITS 16

global _init
extern _init32
_init:
    ; This is where the cpu start executing code at 0x7C00 in 16-bit real mode. What should be done is
    ; * Enter protected mode
    ; * Configure the processor for symmetric multiprocessing
    ; * Enter long mode
    ; * Start scheduling programs

    cli             ; Disable IRQs
    
    in al, 0x70     ; Disable NMI
    or al, 0x80
    out 0x70, al

    mov ax, 0x7C0   ; Set correct segment values
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ss, ax      ; Give program 4K of stack space
    mov sp, _init_end + 4096

    call a20_check
    cmp ax, 1
    je .GDT_load
    call a20_enable

    .GDT_load:
    lgdt [gdtr]

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp gdt_start.CODE:_init32

a20_check:
    pushf
    push ds
    push es
    push di
    push si
 
    cli
 
    xor ax, ax ; ax = 0
    mov es, ax
 
    not ax ; ax = 0xFFFF
    mov ds, ax
 
    mov di, 0x0500
    mov si, 0x0510
 
    mov al, byte [es:di]
    push ax
 
    mov al, byte [ds:si]
    push ax
 
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
 
    cmp byte [es:di], 0xFF
 
    pop ax
    mov byte [ds:si], al
 
    pop ax
    mov byte [es:di], al
 
    mov ax, 0
    je .exit
 
    mov ax, 1
    
    .exit:
    pop si
    pop di
    pop es
    pop ds
    popf
 
    ret
a20_enable:
    call a20_wait
    mov al, 0xAD
    out 0x64, al

    call a20_wait
    mov al, 0xD0
    out 0x64, al

    call a20_wait2
    in al, 0x60
    push eax

    call a20_wait
    mov al, 0xD1
    out 0x64, al

    call a20_wait
    pop eax
    or al, 2
    out 0x64, al

    call a20_wait
    mov al, 0xAE
    out 0x64, al

    call a20_wait
    ret
a20_wait:
    in al, 0x64
    test al, 2
    jnz a20_wait
    ret
a20_wait2:
    in al, 0x64
    test al, 1
    jz a20_wait2
    ret

gdt_start:
    .NULL: equ 0
    dq 0
    .CODE: equ 8
    dw 0xFFFF
    dw 0
    db 0
    db 0b10011010
    db 0b11111100
    db 0
    .DATA: equ 16
    dw 0xFFFF
    dw 0
    db 0
    db 0b10010010
    db 0b11111100
    db 0
gdt_end:
gdtr:
    dw gdt_start - gdt_end - 1
    dd gdt_start

_init_end: