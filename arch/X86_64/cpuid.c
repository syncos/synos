#include <mkos/arch/cpu.h>

struct CPUID getCPUID()
{
    struct CPUID cpu;
    if (!CPUID_enabled())
    {
        cpu.enabled = false;
        return cpu;
    }
    cpu.enabled = true;

    // Get manufacturer
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    // Since the CPUID function returns only the registers, we have to do this in inline assembly
    asm volatile ("mov edi, 0"); // Set edi to 0 = get manufacturer
    asm volatile ("call CPUID"); // Call CPUID
    asm volatile ("mov eax, ebx" : "=r" (ebx));
    asm volatile ("mov eax, ecx" : "=r" (ecx));
    asm volatile ("mov eax, edx" : "=r" (edx));
    // Now that we have the strings we can start decoding them
    // Bytes 0 - 3
    cpu.manufacturer[0]  = ((uint8_t*)&ebx)[3];
    cpu.manufacturer[1]  = ((uint8_t*)&ebx)[2];
    cpu.manufacturer[2]  = ((uint8_t*)&ebx)[1];
    cpu.manufacturer[3]  = ((uint8_t*)&ebx)[0];
    // Bytes 4 - 7
    cpu.manufacturer[4]  = ((uint8_t*)&ecx)[3];
    cpu.manufacturer[5]  = ((uint8_t*)&ecx)[2];
    cpu.manufacturer[6]  = ((uint8_t*)&ecx)[1];
    cpu.manufacturer[7]  = ((uint8_t*)&ecx)[0];
    // Bytes 8 - 11
    cpu.manufacturer[8]  = ((uint8_t*)&edx)[3];
    cpu.manufacturer[9]  = ((uint8_t*)&edx)[2];
    cpu.manufacturer[10] = ((uint8_t*)&edx)[1];
    cpu.manufacturer[11] = ((uint8_t*)&edx)[0];

    // Processor info
    asm volatile ("mov edi, 1");
    asm volatile ("call CPUID");
    asm volatile ("mov esi, eax" : "=S" (cpu.ProcessorInfoEAX));
    asm volatile ("mov esi, edx" : "=S" (cpu.ProcessorInfoEDX));
    asm volatile ("mov esi, ecx" : "=S" (cpu.ProcessorInfoECX));

    return cpu;
}
void halt()
{
    while (1)
    {
        asm ("hlt");
    }
}