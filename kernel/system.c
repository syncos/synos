#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/interrupt.h>
#include <synos/syscall.h>
#include <synos/arch/io.h>
#include <stdio.h>
#include <string.h>

struct SYS_STATE System;

void startup()
{
    // Initialize arch
    // Set interrupt_enabled bool to false
    if (interrupt_enabled()) interrupt_disable();
    System.interrupt_enabled = false;

    // Set up logging and printf (if enabled)
    log_init();
    #ifdef PRINTF_FALLBACK
    printf_init(); // Initialize printf fallback function if enabled
    #endif

    if (arch_init() != 0) panic("Arch initialization error");

    // Initialize memory controller
    mm_init();

    pr_log(INFO, "Starting version %d");//, VERSION);
    printf("Starting version ");
    printf(VERSION);
    printf(" ");
    printf(VERSION_NAME);
    printf("-");
    printf(VERSION_DOMAIN);
    printf("\n");
    // Get cpuid struct
    getCPUINFO(&System.cpuinfo);
    if (System.cpuinfo.enabled == 0)
        panic("CPUID not supported on target system!");
    if (System.cpuinfo.vendor == UNKNOWN)
        pr_log(WARNING, "Couldn't detect CPU vendor! Disabling all vendor specific features.");
    // Get memory info
    getMEMID(&System.memid);
    pr_log(INFO, "Detected memory: %u sections, %u MiB total", System.memid.nEntries, System.memid.totalSize / 1048576);

    // Initialize interrupts
    interrupt_init();

    // Load syscalls
    syscall_init();

    interrupt_enable();

    panic("System reached end of startup function, something has gone wrong.");
}
void panic(char* text)
{
    // This is only a temporary solution. As soon as a working vga driver is working, it should be redirected there
    pr_log(INFO, "Panic encountered! Error message: %d", text);

    printf("The system kernel has encountered a panic!\n");
    printf("Error message: ");
    printf(text);
    printf("\n");

    PrintStackTrace();

    printf("\n");
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