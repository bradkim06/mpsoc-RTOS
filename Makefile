# vi: set ts=8 sw=8 sts=8 noexpandtab:

.EXPORT_ALL_VARIABLES:

TARGET                  := rtos.img
ELF_TARGET              := rtos.elf
SUBDIRS                 := arch kernel
TOPDIR                  := $(shell /bin/pwd)

###########################################

include                 $(TOPDIR)/Config.mk


all: compile $(TARGET) 


$(ELF_TARGET): $(addsuffix /built-in.o,$(SUBDIRS))
	$(LD) $(LDFLAGS) $(LDSCRIPT) -N $^ build/libgcc.a -o $@
	$(NM) $(ELF_TARGET) | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aUw] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)' | sort > Symbols.map


$(TARGET): $(ELF_TARGET)
	$(OBJCOPY) $(OFLAGS) $^ $@
	$(CP) $(TARGET) ~/공유폴더/
	@echo ""



include $(TOPDIR)/Rules.mk





