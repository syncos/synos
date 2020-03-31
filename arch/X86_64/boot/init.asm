section .text
BITS 32

global _start32
_start32:
    mov [mbm], eax
    mov [mbp], ebx

    mov esp, stack_end
    mov eax, 0
    mov [kerror], al

    call CPUID_chk
    cmp eax, 0
    je .no_cpuid

    call X64_chk

    call X64_init

    lgdt [GDT.Pointer]

    jmp GDT.Code:_start
.no_cpuid:
    mov eax, 1
    mov [kerror], al
    jmp hlt
hlt:
    hlt
    jmp hlt

X64_init:
    mov eax, kernel_PDP
    or eax, 0b11
    mov [kernel_AS], eax

    mov eax, kernel_AS
    or eax, 0b11
    mov [kernel_AS + 8 * 511], eax

    mov eax, kernel_PD
    or eax, 0b11
    mov [kernel_PDP], eax

    mov eax, kernel_PT0
    or eax, 0b11
    mov [kernel_PD], eax
    mov eax, kernel_PT1
    or eax, 0b11
    mov [kernel_PD + 8], eax

    xor ecx, ecx
    .loop0:
        mov eax, 0x1000
        mul ecx
        or eax, 0b11
        mov [kernel_PT0 + ecx * 8], eax

        inc ecx
        cmp ecx, 512
        jne .loop0
    xor ecx, ecx
    .loop1:
        mov eax, 0x1000
        mul ecx
        or eax, 0b11
        mov [kernel_PT1 + ecx * 8], eax

        inc ecx
        cmp ecx, 256
        jne .loop1
    
    mov eax, kernel_AS
    mov cr3, eax

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8 | 1 << 11
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret
CPUID_chk:
    pushfd
    pushfd
    xor dword [esp], 0x00200000
    popfd
    pushfd
    pop eax
    xor eax, [esp]
    popfd
    and eax, 0x00200000
    ret
X64_chk:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .no_lm

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .no_lm
    ret
.no_lm:
    mov eax, 2
    mov [kerror], al
    jmp hlt

section .text
BITS 64

global _start
_start:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    xor rbp, rbp

    extern c_entry
    call c_entry

.hlt:
    hlt
    jmp .hlt

section .bss
align 4096
global kernel_AS
kernel_AS:   resb 4096
kernel_PDP:  resb 4096
kernel_PD:   resb 4096
kernel_PT0:  resb 4096
kernel_PT1:  resb 4096

extern kerror

global mbp ; Multiboot(2) pointer
global mbm ; Multiboot(2) magic
mbp: resb 4
mbm: resb 4

global stack_start
global stack_end
stack_start:
    resb 4096
stack_end:

section .data
GDT:
    .Null: equ $ - GDT         ; The null descriptor.
    dw 0xFFFF                    ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 0                         ; Access.
    db 1                         ; Granularity.
    db 0                         ; Base (high).
    .Code: equ $ - GDT         ; The code descriptor.
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10011010b                 ; Access (exec/read).
    db 10101111b                 ; Granularity, 64 bits flag, limit19:16.
    db 0                         ; Base (high).
    .Data: equ $ - GDT         ; The data descriptor.
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10010010b                 ; Access (read/write).
    db 00000000b                 ; Granularity.
    db 0                         ; Base (high).

    .PCode:
    dw 0
    dw 0
    db 0
    db 11111110b
    db 10101111b
    db 0
    .PData:
    dw 0
    dw 0
    db 0
    db 11110010b
    db 0
    db 0
    
    .TSS:
    dw 0
    dw 0
    db 0
    db 0
    db 0
    db 0

    .Pointer:                    ; The GDT-pointer.
    dw $ - GDT - 1             ; Limit.
    dq GDT                     ; Base.