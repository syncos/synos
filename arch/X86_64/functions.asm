BITS 64
section .text

global CPUID_enabled
CPUID_enabled:
    pushfq                               ;Save RFLAGS
    pushfq                               ;Store RFLAGS
    xor qword [esp], 0x00200000          ;Invert the ID bit in stored RFLAGS
    popfq                                ;Load stored RFLAGS (with ID bit inverted)
    pushfq                               ;Store RFLAGS again (ID bit may or may not be inverted)
    pop rax                              ;rax = modified RFLAGS (ID bit may or may not be inverted)
    xor rax, [esp]                       ;rax = whichever bits were changed
    popfq                                ;Restore original RFLAGS
    and rax, 0x00200000                  ;rax = zero if ID bit can't be changed, else non-zero
    cmp rax, 0
    jne .true
    ret
    .true:
        mov rax, 1
        ret
global CPUID
CPUID:
    mov eax, edi
    cpuid
    ret