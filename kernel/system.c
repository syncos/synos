#include <mkos/mkos.h>
#include <stdio.h>

void startup()
{
    // Check that CPUID is supported
    if(!CPUID_enabled())
    {
        panic("CPUID not supported on target system!");
    }
    // Get cpuid struct
    System.cpuid = getCPUID();
    // Get memory info
    System.memid = getMEMID();
}
void panic(char* text)
{
    // This is only a temporary solution. As soon as a working vga driver is working, it should be redirected there
    pr_log(FATAL, "Panic encountered! Error message: %d", text);

    printf("The system kernel has encountered a panic!\n");
    printf("Error message: %d\n\n", text);
    printf("System suspended");

    pr_log(FATAL, "Suspending all processes...");
    // Suspend all processes except essential drivers

    pr_log(FATAL, "Shutting down cores...");
    // Shut down all cores except core 0
    pr_log(FATAL, "All cores except core 0 disabled.");

    // Disable process sheduler
    pr_log(FATAL, "Process scheduler disabled, core passed to kernel.");

    // Shut down systems and halt
    halt();
}