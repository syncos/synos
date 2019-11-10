#include <mkos/mkos.h>
#include <stdio.h>
#include <string.h>

struct SYS_STATE System;

void startup()
{
    pr_log(INFO, "Starting version %d", VERSION);
    printf("Starting version ");
    printf(VERSION);
    printf(" ");
    printf(VERSION_NAME);
    printf("\n");
    // Check that CPUID is supported
    if(!CPUID_enabled())
    {
        panic("CPUID not supported on target system!");
    }
    // Get cpuid struct
    getCPUID(&System.cpuid);
    if (System.cpuid.vendor == UNKNOWN)
    {
        pr_log(WARNING, "Couldn't detect CPU vendor! Disabling all vendor specific features.");
    }
    // Get memory info
    System.memid = getMEMID();
    // Set interrupt_enabled bool to false
    System.interrupt_enabled = false;

    panic("System reached end of startup function, something has gone wrong.");
}
void panic(char* text)
{
    // This is only a temporary solution. As soon as a working vga driver is working, it should be redirected there
    pr_log(INFO, "Panic encountered! Error message: %d", text);

    printf("The system kernel has encountered a panic!\n");
    printf("Error message: ");
    printf(text);
    printf("\n\n");
    printf("System suspended");

    pr_log(INFO, "Suspending all processes...");
    // Suspend all processes except essential drivers

    pr_log(INFO, "Shutting down cores...");
    // Shut down all cores except core 0
    pr_log(INFO, "All cores except core 0 disabled.");

    // Disable process sheduler
    pr_log(INFO, "Process scheduler disabled, core passed to kernel.");

    // Shut down systems and halt
    halt();
}