#include <synos/synos.h>
#include <synos/arch/interrupt.h>
#include "interrupts.h"
#include "controller.h"
#include <stdlib.h>

struct IDT_Entry IDT[256]; // Set the IDT table to a static size, since malloc can sometimes return NULL and that would cause a panic.

struct
{
    enum Interrupt_Controller_Type controller;
}Interrupt_Info;

int interrupt_init(uint8_t syscall_port)
{
    // Set controller
    Interrupt_Info.controller = Controller_Type();
    // Initialize the controller
    IC_INIT();
}