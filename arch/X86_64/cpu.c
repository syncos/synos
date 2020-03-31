#include "cpu.h"
#include <slab.h>
#include <synos.h>
#include <string.h>

struct X64_CPUID cpu;

int cpuinfo()
{
    asm volatile (
        "push %0\n"
        "mov eax, 0\n"
        "cpuid\n"
        "pop rdi\n"
        "mov [rdi], ebx\n"
        "mov [rdi+4], edx\n"
        "mov [rdi+8], ecx"
        :
        : "r" (cpu.vendor_string)
    );

    cpu.vendor_string[12] = 0;
    printk(DEBUG, "CPU vendor string: %s", cpu.vendor_string);

    #define VENDORCMP(vnd) strcmp(cpu.vendor_string, vnd) == 0
         if (VENDORCMP(CPUID_VENDOR_OLDAMD))       {cpu.vendor = OLDAMD;       cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_AMD))          {cpu.vendor = AMD;          cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_INTEL))        {cpu.vendor = INTEL;        cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_VIA))          {cpu.vendor = AMD;          cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_OLDTRANSMETA)) {cpu.vendor = OLDTRANSMETA; cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_TRANSMETA))    {cpu.vendor = TRANSMETA;    cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_CYRIX))        {cpu.vendor = CYRIX;        cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_CENTAUR))      {cpu.vendor = CENTAUR;      cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_NEXGEN))       {cpu.vendor = NEXGEN;       cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_UMC))          {cpu.vendor = UMC;          cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_SIS))          {cpu.vendor = SIS;          cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_NSC))          {cpu.vendor = NSC;          cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_RISE))         {cpu.vendor = RISE;         cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_VORTEX))       {cpu.vendor = VORTEX;       cpu.isVM = 0;}
    else if (VENDORCMP(CPUID_VENDOR_HYGON))        {cpu.vendor = HYGON;        cpu.isVM = 0;}

    // Virtual machines
    else if (VENDORCMP(CPUID_VENDOR_VMWARE))       {cpu.vendor = VMWARE;       cpu.isVM = 1;}
    else if (VENDORCMP(CPUID_VENDOR_XENHVM))       {cpu.vendor = XENHVM;       cpu.isVM = 1;}
    else if (VENDORCMP(CPUID_VENDOR_MICROSOFT_HV)) {cpu.vendor = MICROSOFT_MV; cpu.isVM = 1;}
    else if (VENDORCMP(CPUID_VENDOR_PARALLELS))    {cpu.vendor = PARALLELS;    cpu.isVM = 1;}
    else if (VENDORCMP(CPUID_VENDOR_BHYVE))        {cpu.vendor = BHYVE;        cpu.isVM = 1;}
    else if (VENDORCMP(CPUID_VENDOR_KVM))          {cpu.vendor = KVM;          cpu.isVM = 1;}
    else if (VENDORCMP(CPUID_VENDOR_ACRN))         {cpu.vendor = ACRN;         cpu.isVM = 1;}

    // Else mark as unknown
    // The kernel should give a warning that the cpuid function was not able to detect vendor
    else                                           {cpu.vendor = UNKNOWN;      cpu.isVM = 0; printk(WARNING, "Couldn't detect CPU vendor! Disabling all vendor specific features.");}

    return 1;
}