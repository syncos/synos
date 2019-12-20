#include <synos/arch/arch.h>
#include <synos/arch/cpu.h>
#include <synos/synos.h>
#include "cpuid.h"
#include <string.h>

enum ARCH arch = X86_64;

const int isLittleEndian = 1;
const int isBigEndian = 0;

#define pushaq() asm("push rax"); asm("push rcx"); asm("push rdx"); asm("push rbx"); asm("push rbp"); asm("push rsi"); asm("push rdi")
#define popaq() asm("pop rdi"); asm("pop rsi"); asm("pop rbp"); asm("pop rbx"); asm("pop rdx"); asm("pop rcx"); asm("pop rax")

struct CPUID* __attribute__((optimize("O0"))) getCPUID(struct CPUID* cpu) 
{
    struct X64_CPUID x64ID;
    if (!CPUID_enabled())
    {
        cpu->enabled = false;
        return cpu;
    }
    cpu->enabled = true;
    cpu->asp = (void*)&x64ID;

    // Get vendor
    char vendor[13];
    vendor[12] = 0;
    CPUID_manufacturer((char*)&vendor);
    memcpy(x64ID.vendor_string, (char*)&vendor, 12);

    #define VENDORCMP(vnd) strcmp((char*)&vendor, vnd) == 0
         if (VENDORCMP(CPUID_VENDOR_OLDAMD))       {cpu->vendor = OLDAMD;       cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_AMD))          {cpu->vendor = AMD;          cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_INTEL))        {cpu->vendor = INTEL;        cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_VIA))          {cpu->vendor = AMD;          cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_OLDTRANSMETA)) {cpu->vendor = OLDTRANSMETA; cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_TRANSMETA))    {cpu->vendor = TRANSMETA;    cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_CYRIX))        {cpu->vendor = CYRIX;        cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_CENTAUR))      {cpu->vendor = CENTAUR;      cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_NEXGEN))       {cpu->vendor = NEXGEN;       cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_UMC))          {cpu->vendor = UMC;          cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_SIS))          {cpu->vendor = SIS;          cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_NSC))          {cpu->vendor = NSC;          cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_RISE))         {cpu->vendor = RISE;         cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_VORTEX))       {cpu->vendor = VORTEX;       cpu->isVM = false;}
    else if (VENDORCMP(CPUID_VENDOR_HYGON))        {cpu->vendor = HYGON;        cpu->isVM = false;}

    // Virtual machines
    else if (VENDORCMP(CPUID_VENDOR_VMWARE))       {cpu->vendor = VMWARE;       cpu->isVM = true;}
    else if (VENDORCMP(CPUID_VENDOR_XENHVM))       {cpu->vendor = XENHVM;       cpu->isVM = true;}
    else if (VENDORCMP(CPUID_VENDOR_MICROSOFT_HV)) {cpu->vendor = MICROSOFT_MV; cpu->isVM = true;}
    else if (VENDORCMP(CPUID_VENDOR_PARALLELS))    {cpu->vendor = PARALLELS;    cpu->isVM = true;}
    else if (VENDORCMP(CPUID_VENDOR_BHYVE))        {cpu->vendor = BHYVE;        cpu->isVM = true;}
    else if (VENDORCMP(CPUID_VENDOR_KVM))          {cpu->vendor = KVM;          cpu->isVM = true;}
    else if (VENDORCMP(CPUID_VENDOR_ACRN))         {cpu->vendor = ACRN;         cpu->isVM = true;}

    // Else mark as unknown
    // The kernel should give a warning that the cpuid function was not able to detect vendor
    else                                           {cpu->vendor = UNKNOWN;      cpu->isVM = false;}

    uint32_t regInfo[3];
    CPUID_Info((uint32_t*)&regInfo);

    x64ID.FI_EDX = regInfo[1];
    x64ID.FI_ECX = regInfo[2];

    return cpu;
}
void halt()
{
    while (1)
    {
        asm ("hlt");
    }
}

void readMSR(uint32_t msr, uint32_t *lo, uint32_t *hi)
{
    asm volatile("rdmsr" : "=a"(*lo), "=d"(*hi) : "c"(msr));
}
void writeMSR(uint32_t msr, uint32_t lo, uint32_t hi)
{
    asm volatile("wrmsr" : : "a"(lo), "d"(hi), "c"(msr));
}