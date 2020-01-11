KERNDIR=kernel
KERNDIR_FULL=$(SOURCE_DIR)/kernel
KERNOBJECTS=kernel/system.o kernel/log.o kernel/syscall.o kernel/exception/arithex.o kernel/exception/gpf.o

INITIMGOBJECTS += kernel/kernel.o

include kernel/mm/Makefile

.PHONY: kernel
kernel: kernel/kernel.o
kernel/kernel.o: $(KERNOBJECTS)
	@echo -e "$(SECTIONC)[kernel] $(LINKC)Linking kernel object files -> kernel/kernel.o$(NC)"
	@$(LINK) $(LINK_ARCH) -r $(KERNOBJECTS) -o kernel/kernel.o

kernel/%.o: kernel/%.c
	@echo -e "$(SECTIONC)[kernel] $(COMPILEC)Compiling C object $@$(NC)"
	@$(CC) $(CC_FLAGS) $< -o $@