INTDIR=$(X64DIR)/interrupts
INTDIR_FULL=$(X64DIR_FULL)/interrupts

ARCHOBJECTS += $(INTDIR)/interrupts.o $(INTDIR)/isr.o $(INTDIR)/irq.o $(INTDIR)/pic.o $(INTDIR)/serial.o $(INTDIR)/exceptions.o

ifeq ($(APIC_SUPPORT), TRUE)
ARCHOBJECTS += $(INTDIR)/apic.o
endif