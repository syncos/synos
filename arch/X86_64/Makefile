X64DIR=$(ARCHDIR)/X86_64

DEFINE_VALS += -D_X86_64_

IMG_LINK+=$(X64DIR)/initIMG.ld
ARCHOBJECTS += $(X64DIR)/boot/boot.o $(X64DIR)/cmos.o $(X64DIR)/boot/boot32.o $(X64DIR)/boot/initVar.o $(X64DIR)/cpu.o $(X64DIR)/functions.o $(X64DIR)/memory.o $(X64DIR)/stack.o $(X64DIR)/gdt.o $(X64DIR)/arch.o $(X64DIR)/tss.o $(X64DIR)/multiboot.o $(X64DIR)/boot/multiboot.o $(X64DIR)/boot/init16.o $(X64DIR)/boot/init32.o $(X64DIR)/boot/init64.o $(X64DIR)/init.o $(X64DIR)/printk.o

include $(X64DIR)/interrupts/Makefile

ifdef SYSCALL_INT
DEFINE_VALS += -DSYSCALL_INT=$(SYSCALL_INT)
endif
ifeq ($(APIC_SUPPORT), TRUE)
DEFINE_VALS += -DAPIC_ENABLE
endif

X86_64: $(SOURCE_DIR)/arch/arch.o
$(SOURCE_DIR)/arch/arch.o: $(ARCHOBJECTS)
	@echo -e "$(SECTIONC)[arch] $(LINKC)Linking arch_x86_64 object files -> arch/arch.o$(NC)"
	@$(LINK) $(LINK_ARCH) -r $(ARCHOBJECTS) -o $(SOURCE_DIR)/arch/arch.o

$(X64DIR)/boot/%.o: $(X64DIR)/boot/%.asm
	@$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $< -o $@
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $@$(NC)"

$(X64DIR)/%.o: $(X64DIR)/%.asm
	@$(ASM) $(ASM_FLAGS) $< -o $@
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $@$(NC)"

$(X64DIR)/%.o: $(X64DIR)/%.c
	@$(CC) $(CC_FLAGS) $< -o $@
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling C object $@$(NC)"

.PHONY: grub
grub:
	@echo -e "$(SECTIONC)[install]$(INFOC) Installing synos along with GRUB to iso file $(INSTALL_DRIVE)...$(NC)"
	@mkdir -p $(ROOT_DIR)/boot/grub
	@cp conf/GRUB2.cfg.default $(ROOT_DIR)/boot/grub/grub.cfg
	@cp $(KERNEL_OUT) $(ROOT_DIR)/boot/synos
	@grub-mkrescue -o synos.iso $(ROOT_DIR)
	@rm -rf $(ROOT_DIR)
	@echo -e "$(SECTIONC)[install]$(INFOC) $(INSTALL_DRIVE) created!$(NC)"
.PHONY: qemu
qemu:
	@echo -e "$(SECTIONC)[qemu]$(INFOC) Starting qemu with command: qemu-system-x86_64 -cpu qemu64 -display gtk -rtc base="2020-01-01",clock=vm -smp 2 -m 2G -vga std -cdrom $(INSTALL_DRIVE) -gdb tcp::9000 -S -monitor stdio $(QEMU_ARGS)$(NC)"
	@qemu-system-x86_64 -cpu qemu64 -display gtk -rtc base="2020-01-01",clock=vm -smp 2 -m 2G -vga std -cdrom $(INSTALL_DRIVE) -gdb tcp::9000 -S -monitor stdio
.PHONY: install
install:
	@echo -e "$(SECTIONC)[install]$(INFOC) Installing synos to $(INSTALL_DIR)/synos ...$(NC)"
	@cp $(ROOT_DIR)/boot/synos $(INSTALL_DIR)/synos
	@chmod 644 $(INSTALL_DIR)/synos
	@echo -e "$(SECTIONC)[install]$(INFOC) Done!$(NC)"