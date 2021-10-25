# vi: set ts=8 sw=8 sts=8 noexpandtab:


compile:
	@for dir in $(SUBDIRS); do \
	make -C $$dir || exit $?; \
	done


clean:
	@for dir in $(SUBDIRS); do \
	make -C $$dir clean; \
	done
	rm -rf *.o *.i *.s $(TARGET) 
ifeq ($(shell /bin/pwd),$(TOPDIR))
	rm -rf $(ELF_TARGET) Symbols.map
	@echo -e " "
endif




