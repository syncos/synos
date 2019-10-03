section .rodata

global mbp
mbp: dd 0
global mbm
mbm: dd 0

section .bss
align 4096 ; Needs to be 4KiB aligned for paging to work

global stack_bottom
stack_bottom:
    resb 4096 * 1
global stack_top
stack_top: