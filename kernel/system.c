#include <synos/synos.h>
#include <synos/mm.h>
#include <synos/arch/interrupt.h>
#include <synos/syscall.h>
#include <synos/arch/io.h>
#include <stdbool.h>
#include <string.h>

struct SYS_STATE System;

void startup()
{
    // Initialize arch
    // Set interrupt_enabled bool to false
    if (interrupt_enabled()) interrupt_disable();
    System.interrupt_enabled = false;

    arch_init();

    // Get memory info
    getMEMID(&System.memid);

    // Initialize memory controller
    mm_init();

    // Set up logging and printf (if enabled)
    printk_init();

    printk(INFO, "Starting version %s %s-%s", VERSION, VERSION_NAME, VERSION_DOMAIN);
    // Get cpuid struct
    getCPUINFO(&System.cpuinfo);
    if (System.cpuinfo.enabled == false)
        panic("CPUID not supported on target system!");
    if (System.cpuinfo.vendor == UNKNOWN)
        printk(WARNING, "Couldn't detect CPU vendor! Disabling all vendor specific features.");
    printk(INFO, "Detected memory: %u sections, %u MiB total", System.memid.nEntries, System.memid.totalSize / 1048576);

    // Initialize interrupts
    interrupt_init();

    // Load syscalls
    syscall_init();

    interrupt_enable();

    panic("System reached end of startup function!");
}
void panic(char* text)
{
    printk(FATAL, "The system kernel has encountered a panic!\n");
    printk(FATAL, "Error message: %s", text);

    PrintStackTrace();

    printk(WARNING, "System suspended");

    printk(INFO, "Suspending all processes...");
    // Suspend all processes except essential drivers

    printk(INFO, "Shutting down cores...");
    // Shut down all cores except core 0
    printk(INFO, "All cores except core 0 disabled.");

    // Disable process sheduler
    printk(INFO, "Process scheduler disabled, core passed to kernel.");

    // Shut down systems and halt
    halt();
}