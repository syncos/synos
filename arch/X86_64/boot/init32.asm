section .text
global _start
BITS 32

%INCLUDE "initVar.inc"

; Initially, the bootloader dumps us in 32-bit protective mode. 
; This code will not be included if the bootloader drops us in 64-bit mode.
; What we need to do now is to call everything that needs to be executed before jumping to 64-bit mode

_start:
    mov esp, stack_top