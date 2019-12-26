#include "interrupts.h"
#include <synos/arch/io.h>
#include "../cpuid.h"

extern void PIC_disable();

const uintptr_t APIC_base = 0x1000;
const uint8_t IRQ_spurious = 0xFF;

// ------------------------------------------------------------------------------------------------
// Local APIC Registers
#define LAPIC_ID                        0x0020  // Local APIC ID
#define LAPIC_VER                       0x0030  // Local APIC Version
#define LAPIC_TPR                       0x0080  // Task Priority
#define LAPIC_APR                       0x0090  // Arbitration Priority
#define LAPIC_PPR                       0x00a0  // Processor Priority
#define LAPIC_EOI                       0x00b0  // EOI
#define LAPIC_RRD                       0x00c0  // Remote Read
#define LAPIC_LDR                       0x00d0  // Logical Destination
#define LAPIC_DFR                       0x00e0  // Destination Format
#define LAPIC_SVR                       0x00f0  // Spurious Interrupt Vector
#define LAPIC_ISR                       0x0100  // In-Service (8 registers)
#define LAPIC_TMR                       0x0180  // Trigger Mode (8 registers)
#define LAPIC_IRR                       0x0200  // Interrupt Request (8 registers)
#define LAPIC_ESR                       0x0280  // Error Status
#define LAPIC_ICRLO                     0x0300  // Interrupt Command
#define LAPIC_ICRHI                     0x0310  // Interrupt Command [63:32]
#define LAPIC_TIMER                     0x0320  // LVT Timer
#define LAPIC_THERMAL                   0x0330  // LVT Thermal Sensor
#define LAPIC_PERF                      0x0340  // LVT Performance Counter
#define LAPIC_LINT0                     0x0350  // LVT LINT0
#define LAPIC_LINT1                     0x0360  // LVT LINT1
#define LAPIC_ERROR                     0x0370  // LVT Error
#define LAPIC_TICR                      0x0380  // Initial Count (for Timer)
#define LAPIC_TCCR                      0x0390  // Current Count (for Timer)
#define LAPIC_TDCR                      0x03e0  // Divide Configuration (for Timer)

// ------------------------------------------------------------------------------------------------
// Interrupt Command Register

// Delivery Mode
#define ICR_FIXED                       0x00000000
#define ICR_LOWEST                      0x00000100
#define ICR_SMI                         0x00000200
#define ICR_NMI                         0x00000400
#define ICR_INIT                        0x00000500
#define ICR_STARTUP                     0x00000600

// Destination Mode
#define ICR_PHYSICAL                    0x00000000
#define ICR_LOGICAL                     0x00000800

// Delivery Status
#define ICR_IDLE                        0x00000000
#define ICR_SEND_PENDING                0x00001000

// Level
#define ICR_DEASSERT                    0x00000000
#define ICR_ASSERT                      0x00004000

// Trigger Mode
#define ICR_EDGE                        0x00000000
#define ICR_LEVEL                       0x00008000

// Destination Shorthand
#define ICR_NO_SHORTHAND                0x00000000
#define ICR_SELF                        0x00040000
#define ICR_ALL_INCLUDING_SELF          0x00080000
#define ICR_ALL_EXCLUDING_SELF          0x000c0000

// Destination Field
#define ICR_DESTINATION_SHIFT           24

#define IA32_APIC_BASE_MSR 0x1B
#define IA32_APIC_BASE_MSR_BSP 0x100 // Processor is a BSP
#define IA32_APIC_BASE_MSR_ENABLE 0x800

#define APIC_ENABLE_SPR (1 << 8)
#define APIC_EOI_MESSAGE_DISABLE (1 << 12)

static void set_apic_base(uintptr_t apic)
{
    uint32_t edx = 0;
    uint32_t eax = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;

    writeMSR(IA32_APIC_BASE_MSR, eax, edx);
}
static void apic_spurious_set()
{
    idt_set(IRQ_spurious, (uintptr_t)isr_spurious, INT_GATE_INTERRUPT);

    *((uint32_t*)(APIC_base + LAPIC_SVR)) = IRQ_spurious | APIC_ENABLE_SPR | APIC_EOI_MESSAGE_DISABLE;
}

int APIC_Configure(uint8_t offset)
{
    PIC_disable();
    set_apic_base(APIC_base); // Set the apic base to recide in low-mem

    apic_spurious_set();

    return 0;
}

#define APIC_EOI_REG (APIC_base + 0xB0)
#define APIC_EOI_CODE 0
void APIC_SOI(uint8_t irq)
{

}
void APIC_EOI(uint8_t irq)
{
    *((uint32_t*)APIC_EOI_REG) = APIC_EOI_CODE;
}

void APIC_IRQ_save()
{

}
void APIC_IRQ_kill()
{

}
void APIC_IRQ_restore()
{
    
}

void APIC_disable()
{
    uint32_t eax, edx;
    readMSR(IA32_APIC_BASE_MSR, &eax, &edx);

    edx  = 0;
    eax &= ~(1UL << 11); // Disable APIC
    writeMSR(IA32_APIC_BASE_MSR, eax, edx);
}