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
global CPUID_manufacturer
CPUID_manufacturer:
    push rbx
    push rdx
    push rcx

    xor eax, eax
    cpuid
    mov [rdi], ebx
    mov [rdi+4], edx
    mov [rdi+8], ecx
    
    pop rcx
    pop rdx
    pop rbx
    mov rax, rdi
    ret
global CPUID_Info
CPUID_Info:
    push rdx
    push rcx
    push rbx

    mov eax, 1
    cpuid
    mov [rdi], eax
    mov [rdi+4], edx
    mov [rdi+8], ecx

    pop rbx
    pop rcx
    pop rdx
    mov rax, rdi
    ret
global RFLAGS
RFLAGS:
    pushfq
    pop rax
    ret

global gdtr_store
gdtr_store:
    sgdt [rdi]
    ret

global TLB_flush
TLB_flush:
    mov rax, cr3
    mov cr3, rax
    ret