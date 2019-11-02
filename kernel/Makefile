KERNDIR=kernel
KERNDIR_FULL=$(SOURCE_DIR)/kernel
KERNOBJECTS=kernel/system.o kernel/log.o

INITIMGOBJECTS += kernel/kernel.o

.PHONY: kernel
kernel: $(KERNOBJECTS)
	@echo -e "$(SECTIONC)[kernel] $(LINKC)Linking kernel object files -> kernel/kernel.o$(NC)"
	@$(LINK) -r $(KERNOBJECTS) -o kernel/kernel.o
kernel/system.o: kernel/system.c
	@echo -e "$(SECTIONC)[kernel] $(COMPILEC)Compiling C object kernel/system.o$(NC)"
	@$(CC) $(CC_FLAGS) kernel/system.c -o kernel/system.o
kernel/log.o: kernel/log.c
	@echo -e "$(SECTIONC)[kernel] $(COMPILEC)Compiling C object kernel/log.o$(NC)"
	@$(CC) $(CC_FLAGS) kernel/log.c -o kernel/log.o