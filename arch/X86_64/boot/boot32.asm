section .text
global _start
BITS 32

%INCLUDE "initVar.inc"
%DEFINE SCREEN_WIDTH 80
%DEFINE VGA_ADDRESS_D 0xB8000

; Initially, the bootloader dumps us in 32-bit protective mode. 
; This code will not be included if the bootloader drops us in 64-bit mode.
; What we need to do now is to call everything that needs to be executed before jumping to 64-bit mode

_start:
    mov esp, stack_top
    mov [mbm], eax ; Multiboot/Multiboot2 magic   (if present)
    mov [mbp], ebx ; Multiboot/Multiboot2 pointer (if present)

    call _CPUID_enabled32
    call _ISX64_32

    ; We've now checked that the system supports X64. Now we need to initialize page tables and GDT to be able to enter 64-bit.
    ; All of these will be changed later
    call _64INIT

    ; All that's left to do is to load a temporarly GDT
    lgdt [GDT.Pointer]

    ; Then do a far jump to 64-bit code
    extern _start64
    jmp GDT.Code:_start64

_ISX64_32: ; Check if the target system is x64
    ; test if extended processor info in available
    mov eax, 0x80000000    ; implicit argument for cpuid
    cpuid                  ; get highest supported argument
    cmp eax, 0x80000001    ; it needs to be at least 0x80000001
    jb .no_long_mode       ; if it's less, the CPU is too old for long mode

    ; use extended info to test if long mode is available
    mov eax, 0x80000001    ; argument for extended processor info
    cpuid                  ; returns various feature bits in ecx and edx
    test edx, 1 << 29      ; test if the LM-bit is set in the D-register
    jz .no_long_mode       ; If it's not set, there is no long mode
    ret
    .no_long_mode:
        mov esi, str_no_x64
        call _print
        hlt
_CPUID_enabled32:
    pushfd                               ;Save EFLAGS
    pushfd                               ;Store EFLAGS
    xor dword [esp],0x00200000           ;Invert the ID bit in stored EFLAGS
    popfd                                ;Load stored EFLAGS (with ID bit inverted)
    pushfd                               ;Store EFLAGS again (ID bit may or may not be inverted)
    pop eax                              ;eax = modified EFLAGS (ID bit may or may not be inverted)
    xor eax,[esp]                        ;eax = whichever bits were changed
    popfd                                ;Restore original EFLAGS
    and eax,0x00200000                   ;eax = zero if ID bit can't be changed, else non-zero
    cmp eax, 0
    je .no_CPUID
    ret
    .no_CPUID:
        mov esi, str_no_cpuid
        call _print
        hlt

_64INIT:
    ; Start with setting up a temporary page tables
    ; Start by mapping a PDP table to PML4
    mov eax, PDP_T
    or eax, 0b11 ; Present + Writable
    mov [PML4_T], eax

    ; Map PD table to PDP
    mov eax, PD_T
    or eax, 0b11 ; Present + Writable
    mov [PDP_T], eax

    ; Map whole PD table with 2 MB pages creating 1 GB of allocated space
    xor ecx, ecx ; Use ecx a counter
    .loop:
        mov eax, 0x200000
        mul ecx ; eax now hold the physical address
        or eax, 0b10000011 ; present + writable + huge
        mov [PD_T + ecx * 8], eax

        inc ecx
        cmp ecx, 512
        jne .loop
    
    ; Once done with the page tables, we enable 64-bit mode and enable paging

    ; First load the address of PML4 to the cr3 register
    mov eax, PML4_T
    mov cr3, eax

    ; Set PAE-bit (Physical Address Extension) in cr4
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Set the long mode (64-bit mode) bit in EFER MSR (Model Specific Register)
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging in cr0
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret

; Screen related functions
_setCursorPos: ; eax = x, ebx = y
    push eax
    push ebx
    push ecx
    mov [x], eax
    mov [y], ebx
    xchg eax, ebx
    mov ecx, SCREEN_WIDTH
    mul ecx
    add eax, ebx
    mov ecx, 2
    mul ecx
    mov [cursor], eax
    pop ecx
    pop ebx
    pop eax
    ret
_XY_calc:
    push eax
    push edx
    push ecx
    mov eax, [cursor]
    mov ecx, SCREEN_WIDTH
    div ecx
    mov [x], edx
    mov [y], eax
    pop ecx
    pop edx
    pop eax
    ret
_print: ; esi = pointer to string
    push ebx
    push esi
    push eax
    push ecx
    mov ebx, VGA_ADDRESS_D
    mov ecx, [cursor]
    add ebx, ecx
    .loop:
        lodsb
        cmp al, 0
        je .done
        cmp al, 0xA
        je .jmp_line
        mov ah, 0b00001111
        mov [ebx], ax
        add ebx, 2
        mov ecx, [cursor]
        add ecx, 2
        mov [cursor], ecx
        call _XY_calc
        jmp .loop
        .jmp_line:
            push eax
            push ebx
            call _XY_calc ; Just in case
            mov eax, [x]
            mov ebx, [y]
            add ebx, 1
            call _setCursorPos
            pop ebx
            pop eax
            jmp .loop
    .done:
        pop ecx
        pop eax
        pop esi
        pop ebx
        ret

section .rodata

; Local variables
cursor dd 0 ; Cursor postition
x dd 0
y dd 0

; Strings
str_no_mb2   db 'Panic: system not booted with multiboot2! ', 0x0A, 'System halted', 0x00
str_no_cpuid db 'Panic: no CPUID detected on system! ', 0x0A, 'System halted', 0x00
str_no_x64   db 'Panic: x86-64 architecture not detected, wrong architecture selected! ', 0x0A, 'System halted', 0x00 

; Temp. GDT
GDT:                           ; Global Descriptor Table (64-bit).
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
    .Pointer:                    ; The GDT-pointer.
    dw $ - GDT - 1             ; Limit.
    dq GDT                     ; Base.