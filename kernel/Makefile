KERNDIR=kernel
KERNDIR_FULL=$(SOURCE_DIR)/kernel
KERNOBJECTS=kernel/mm.o kernel/page.o kernel/slab.o kernel/printk.o

INITIMGOBJECTS += kernel/kernel.o

.PHONY: kernel
kernel: kernel/kernel.o
kernel/kernel.o: $(KERNOBJECTS)
	@echo -e "$(SECTIONC)[kernel] $(LINKC)Linking kernel object files -> kernel/kernel.o$(NC)"
	@$(LINK) $(LINK_ARCH) -r $(KERNOBJECTS) -o kernel/kernel.o

kernel/%.o: kernel/%.c
	@$(CC) $(CC_FLAGS) $< -o $@
	@echo -e "$(SECTIONC)[kernel] $(COMPILEC)Compiling C object $@$(NC)"