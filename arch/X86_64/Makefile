X64DIR=$(ARCHDIR)/X86_64
include $(X64DIR)/.config

IMG_LINK+=$(X64DIR)/initIMG.ld
ARCHOBJECTS += $(X64DIR)/boot/init.o $(X64DIR)/boot/init32.o $(X64DIR)/boot/initVar.o $(X64DIR)/ports.o $(X64DIR)/cpuid.o $(X64DIR)/functions.o $(X64DIR)/memory.o $(X64DIR)/printf.o $(X64DIR)/stack.o $(X64DIR)/gdt.o

PF_ARGS=

include $(X64DIR)/interrupts/Makefile

ifeq ($(PRINTF_FALLBACK), TRUE)
DEFINE_VALS += -DPRINTF_FALLBACK
endif
ifeq ($(LOAD_SYSTEM), MULTIBOOT2)
ARCHOBJECTS += $(X64DIR)/multiboot2.o
ARCHOBJECTS += $(X64DIR)/boot/multiboot2.o
else
ifeq ($(LOAD_SYSTEM), MULTIBOOT)
ARCHOBJECTS += $(X64DIR)/multiboot.o
ARCHOBJECTS += $(X64DIR)/boot/multiboot.o
endif
endif
ifeq ($(ENABLE_MEMSTACK), TRUE)
DEFINE_VALS += -DMEMSTACK_ENABLE
endif
ifdef SYSCALL_IRQ
DEFINE_VALS += -DSYSCALL_IRQ=$(SYSCALL_IRQ)
endif

arch_x86_64: $(ARCHOBJECTS)
	@echo -e "$(SECTIONC)[arch] $(LINKC)Linking arch_x86_64 object files -> arch/arch.o$(NC)"
	@$(LINK) -r $(ARCHOBJECTS) -o $(SOURCE_DIR)/arch/arch.o

$(X64DIR)/boot/%.o: $(X64DIR)/boot/%.asm
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $@$(NC)"
	@$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $< -o $@

$(X64DIR)/%.o: $(X64DIR)/%.asm
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $@$(NC)"
	@$(ASM) $(ASM_FLAGS) $< -o $@

$(X64DIR)/%.o: $(X64DIR)/%.c
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling C object $@$(NC)"
	@$(CC) $(CC_FLAGS) $< -o $@