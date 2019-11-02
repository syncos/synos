#include <mkos/mkos.h>

void startup()
{
    // Check that CPUID is supported
    if(!CPUID_enabled())
    {
        panic("CPUID not supported on target system!");
    }
    // Get cpuid struct
    System.cpuid = getCPUID();
}
void panic(char* text)
{
    halt();
}