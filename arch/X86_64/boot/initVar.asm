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

global PML4_T
PML4_T:
    resb 4096
; These others are only used temporarily
global PDP_T
PDP_T:
    resb 4096
global PD_T
PD_T:
    resb 4096
global PT_T
PT_T:
    resb 4096