#ifndef ARCH_CPU_H
#define ARCH_CPU_H
#include <inttypes.h>

enum Manufacturer
{
    OLDAMD,
    AMD,
    INTEL,
    VIA,
    OLDTRANSMETA,
    TRANSMETA,
    CYRIX,
    CENTAUR,
    NEXGEN,
    UMC,
    SIS,
    NSC,
    RISE,
    VORTEX,
    HYGON,

    VMWARE,
    XENHVM,
    MICROSOFT_MV,
    PARALLELS,
    BHYVE,
    KVM,
    ACRN,

    UNKNOWN
};
struct CPUID
{
    bool enabled;
    void* asp; // Architecture Specific Properties

    enum Manufacturer vendor;
    bool isVM;

    char fbp[1];
};

extern const int isLittleEndian;
extern const int isBigEndian;

struct CPUID*   getCPUID(struct CPUID*);
extern uint64_t CPUID_enabled();
extern void     CPUID(uint32_t eax);
void            halt();
#endif