section .rodata

mbp: dd 0
mbm: dd 0

section .bss
align 4096 ; Needs to be 4KiB aligned for paging to work

stack_bottom:
    resb 4096 * 1
stack_top: