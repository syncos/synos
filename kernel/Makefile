KERNDIR=kernel
KERNDIR_FULL=$(SOURCE_DIR)/kernel
KERNOBJECTS=kernel/system.o kernel/log.o

INITIMGOBJECTS += kernel/kernel.o

.PHONY: kernel
kernel: $(KERNOBJECTS)
	@echo -e "$(SECTIONC)[kernel] $(LINKC)Linking kernel object files -> kernel/kernel.o$(NC)"
	@$(LINK) -r $(KERNOBJECTS) -o kernel/kernel.o

kernel/%.o: kernel/%.c
	@echo -e "$(SECTIONC)[kernel] $(COMPILEC)Compiling C object $@$(NC)"
	@$(CC) $(CC_FLAGS) $< -o $@