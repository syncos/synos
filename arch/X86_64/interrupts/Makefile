INTDIR=$(X64DIR)/interrupts
INTDIR_FULL=$(X64DIR_FULL)/interrupts

ARCHOBJECTS += $(INTDIR)/interrupt_functions.o $(INTDIR)/interrupt_api.o $(INTDIR)/syscalls.o

$(INTDIR)/interrupt_functions.o: $(INTDIR)/interrupt_functions.asm
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $(INTDIR)/interrupt_functions.o$(NC)"
	@$(ASM) $(ASM_FLAGS) $(INTDIR)/interrupt_functions.asm -o $(INTDIR)/interrupt_functions.o

$(INTDIR)/interrupt_api.o: $(INTDIR)/interrupt_api.c
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling C object $(INTDIR)/interrupt_api.o$(NC)"
	@$(CC) $(CC_FLAGS) $(INTDIR)/interrupt_api.c -o $(INTDIR)/interrupt_api.o

$(INTDIR)/syscalls.o: $(INTDIR)/syscalls.c
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling C object $(INTDIR)/syscalls.o$(NC)"
	@$(CC) $(CC_FLAGS) $(INTDIR)/syscalls.c -o $(INTDIR)/syscalls.o