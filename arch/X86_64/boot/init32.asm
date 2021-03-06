section .init_X86
BITS 32

extern cInit_sl

global _init32
_init32:
    cli

    mov ax, 16
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    call _CPUID_enabled32
    call _ISX64_32

    call _64INIT

    lgdt [GDT.Pointer]

    extern _init64
    jmp GDT.Code:_init64
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
        mov byte [cInit_sl], 0
        hlt
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
        mov byte [cInit_sl], 0
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
section .bss
align 4096

PML4_T:
    resb 4096
PDP_T:
    resb 4096
PD_T:
    resb 4096

section .rodata
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