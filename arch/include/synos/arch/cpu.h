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
struct CPUINFO
{
    bool enabled;
    void* asp; // Architecture Specific Properties

    enum Manufacturer vendor;
    bool isVM;
};

extern const int isLittleEndian;
extern const int isBigEndian;

struct CPUINFO*   getCPUINFO(struct CPUINFO*);
void              halt();
#endif