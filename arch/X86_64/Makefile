X64DIR=$(ARCHDIR)/X86_64

CC_FLAGS += -m64
CXX_FLAGS += -m64
DEFINE_VALS += -D_64BIT_ -D_X86_64_

IMG_LINK+=$(X64DIR)/linkerscript.ld
ARCHOBJECTS += $(X64DIR)/boot/init.o $(X64DIR)/boot/headers.o $(X64DIR)/init.o $(X64DIR)/inline.o $(X64DIR)/page.o $(X64DIR)/spinlock.o $(X64DIR)/framebuffer.o $(X64DIR)/cpu.o

X86_64: $(SOURCE_DIR)/arch/arch.o
$(SOURCE_DIR)/arch/arch.o: $(ARCHOBJECTS)
	@echo -e "$(SECTIONC)[arch] $(LINKC)Linking arch_x86_64 object files -> arch/arch.o$(NC)"
	@$(LINK) $(LINK_ARCH) -r $(ARCHOBJECTS) -o $(SOURCE_DIR)/arch/arch.o

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