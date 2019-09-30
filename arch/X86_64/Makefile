X64DIR=$(ARCHDIR)/X86_64

IMG_LINK+=$(X64DIR)/initIMG.ld
ARCHOBJECTS += $(X64DIR)/boot/init.o $(X64DIR)/boot/init32.o $(X64DIR)/boot/initVar.o $(X64DIR)/ports.o

ifeq ($(LOAD_SYSTEM), MULTIBOOT2)
ARCHOBJECTS += $(X64DIR)/multiboot2.o
ARCHOBJECTS += $(X64DIR)/boot/multiboot2.o
else
ifeq ($(LOAD_SYSTEM), MULTIBOOT)
ARCHOBJECTS += $(X64DIR)/multiboot.o
ARCHOBJECTS += $(X64DIR)/boot/multiboot.o
endif
endif

arch_x86_64: $(ARCHOBJECTS)
	@echo -e "$(SECTIONC)[arch] $(LINKC)Linking arch_x86_64 object files -> arch/arch.o$(NC)"
	@$(LINK) -r $(ARCHOBJECTS) -o $(SOURCE_DIR)/arch/arch.o

$(X64DIR)/boot/init.o: $(X64DIR)/boot/init.asm
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $(X64DIR)/boot/init.o$(NC)"
	@$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $(X64DIR)/boot/init.asm -o $(X64DIR)/boot/init.o

$(X64DIR)/boot/init32.o: $(X64DIR)/boot/init32.asm
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $(X64DIR)/boot/init32.o$(NC)"
	@$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $(X64DIR)/boot/init32.asm -o $(X64DIR)/boot/init32.o

$(X64DIR)/boot/initVar.o: $(X64DIR)/boot/initVar.asm
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $(X64DIR)/boot/initVar.o$(NC)"
	@$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $(X64DIR)/boot/initVar.asm -o $(X64DIR)/boot/initVar.o

$(X64DIR)/ports.o: $(X64DIR)/ports.c
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling C object $(X64DIR)/ports.o$(NC)"
	@$(CC) $(CC_FLAGS) $(X64DIR)/ports.c -o $(X64DIR)/ports.o

$(X64DIR)/multiboot2.o: $(X64DIR)/multiboot2.c
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling C object $(X64DIR)/multiboot2.o$(NC)"
	@$(CC) $(CC_FLAGS) $(X64DIR)/multiboot2.c -o $(X64DIR)/multiboot2.o
$(X64DIR)/boot/multiboot2.o: $(X64DIR)/boot/multiboot2.asm
	@echo -e "$(SECTIONC)[arch] $(COMPILEC)Compiling ASM object $(X64DIR)/boot/multiboot2.o$(NC)"
	@$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $(X64DIR)/boot/multiboot2.asm -o $(X64DIR)/boot/multiboot2.o