# vi: set ts=8 sw=8 sts=8 noexpandtab:

TARGET_ARCH				:= arm
TARGET_SUB_ARCH			:= cortex_a8
#CROSS_PREFIX            := /home/yhc/bin/arm-2010.09/bin/arm-none-linux-gnueabi-
CROSS_PREFIX            := /home/yhc/bin/arm-eabi-4.3.1/bin/arm-eabi-


######################################################

CC                      := $(CROSS_PREFIX)gcc
AS                      := $(CROSS_PREFIX)as
LD                      := $(CROSS_PREFIX)ld
NM                      := $(CROSS_PREFIX)nm
STRIP                   := $(CROSS_PREFIX)strip
OBJCOPY                 := $(CROSS_PREFIX)objcopy
CP                      := /bin/cp -f
RM                      := /bin/rm -rf


INCLUDES                := -I. -I$(TOPDIR)/include
DEFINES                 := -D__ARCH_$(TARGET_ARCH)__ -D__SUB_ARCH_$(TARGET_SUB_ARCH)__ 
DEFINES                 += -DDEBUG

CFLAGS                  := -nostdinc 
#CFLAGS                	+= -O2 -fomit-frame-pointer
CFLAGS					+= -mcpu=iwmmxt -mtune=iwmmxt -mabi=aapcs-linux
CFLAGS                  += -fno-strict-aliasing -fno-common -fno-builtin
CFLAGS                  += -W -Wall -Wstrict-prototypes
CFLAGS                  += -Wno-unused-variable -Wno-unused-function -Wno-unused-label -Wno-unused-parameter
CFLAGS                  += $(INCLUDES)
CFLAGS                  += $(DEFINES)
CFLAGS                  += -ggdb
#CFLAGS 	            += -save-temps

OFLAGS                  := -O binary -R .note -R .comment -S
LDFLAGS                 := -nostdlib -nostartfiles -nodefaultlibs -static -X
LDRELOC					:= -r
LDSCRIPT                := -T $(TOPDIR)/arch/kernel.lds



######################################################

.SUFFIXES : .o .c .S

%.o:%.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o:%.S
	$(CC) $(CFLAGS) -c $< -o $@

######################################################




