# vi: set ts=8 sw=8 sts=8 noexpandtab:

ifndef TOPDIR
TOPDIR := ..
endif

include	$(TOPDIR)/Config.mk


TARGET      := built-in.o
SUBDIRS     :=

OBJS		:= $(patsubst %.c, %.o, $(wildcard *.c))
OBJS		+= $(patsubst %.S, %.o, $(wildcard *.S))


all : compile $(OBJS)
	$(LD) $(LDFLAGS) $(LDRELOC) $(OBJS) -o $(TARGET)



include $(TOPDIR)/Rules.mk



