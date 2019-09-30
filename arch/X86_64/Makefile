X64DIR=$(ARCHDIR)/X86_64

IMG_LINK+=$(X64DIR)/initIMG.ld
ARCHOBJECTS += $(X64DIR)/boot/init.o $(X64DIR)/boot/init32.o $(X64DIR)/boot/initVar.o

arch_x86_64: $(ARCHOBJECTS)
	$(LINK) -r $(ARCHOBJECTS) -o $(SOURCE_DIR)/arch/arch.o

$(X64DIR)/boot/init.o: $(X64DIR)/boot/init.asm
	$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $(X64DIR)/boot/init.asm -o $(X64DIR)/boot/init.o

$(X64DIR)/boot/init32.o: $(X64DIR)/boot/init32.asm
	$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $(X64DIR)/boot/init32.asm -o $(X64DIR)/boot/init32.o

$(X64DIR)/boot/initVar.o: $(X64DIR)/boot/initVar.asm
	$(ASM) $(ASM_FLAGS) -i $(X64DIR)/boot/ $(X64DIR)/boot/initVar.asm -o $(X64DIR)/boot/initVar.o