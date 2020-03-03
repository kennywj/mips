
CROSS=mipsel-none-elf-

CC=${CROSS}gcc
AS=${CROSS}as
LD=${CROSS}gcc
AR=${CROSS}ar
OBJCOPY=${CROSS}objcopy
OBJDUMP=${CROSS}objdump
SIZE=${CROSS}size

TARGET = paectrl

CURDIR  = .
OBJDIR	= $(CURDIR)/obj
SRCDIR  = $(CURDIR)/src

SRCS = start.s main.c

HEX		= $(OBJDIR)/$(TARGET).hex
BIN		= $(OBJDIR)/$(TARGET).bin
ELF		= $(OBJDIR)/$(TARGET).elf
MAP		= $(OBJDIR)/$(TARGET).map
LST		= $(OBJDIR)/$(TARGET).lst
VLG		= $(OBJDIR)/$(TARGET).v

OBJS	:= $(addprefix $(OBJDIR)/, $(addsuffix .o,$(basename $(SRCS))))
OBJS	:= $(OBJS:.c=.o)
OBJS	:= $(OBJS:.s=.o)
OBJS	:= $(OBJS:.S=.o)

VPATH   := $(SRCDIR) 

# C options
CFLAGS	= -c -g -Wall -EL -mips1

# LD options
LDFLAGS	= -Wl,-Map=$(MAP) -static -nostdlib
# -T supply your own linker script
LDFLAGS	+= -T $(TARGET).ld

.SILENT :

.PHONY: all start


all: start $(ELF) $(HEX) $(VLG) $(BIN) $(LST) $(OK)

build: clean all

start:
	@echo --- building $(TARGET)

$(LST): $(ELF)
	@echo --- making asm-lst...
	@$(OBJDUMP) -D -EL $(ELF) > $(LST)

$(OK): $(ELF)
	@$(SIZE) $(ELF)
	@echo "Errors: none"

$(HEX): $(ELF)
	@echo --- make hex...
	@$(OBJCOPY) --gap-fill 0 -S -O ihex $(ELF) $(HEX)

$(BIN): $(ELF)
	@echo --- make binary...
	@$(OBJCOPY) --gap-fill 0 -S -O binary $(ELF) $(BIN)

$(VLG): $(ELF)
	@echo --- make verlog...
	@$(OBJCOPY) --gap-fill 0 -S -O verilog $(ELF) $(VLG)

$(ELF):	$(OBJS)
	@echo --- linking...
	$(LD) $(OBJS) $(LDFLAGS) -o "$(ELF)"

$(OBJDIR)/%.o: %.c
	@echo --- compiling $<...
	$(CC) $(CFLAGS) -o $@ $<

$(OBJDIR)/%.o: %.S
	@echo --- assembling $<...
	$(CC) $(CFLAGS) -o $@ $<

$(OBJDIR)/%.o: %.s
	@echo --- assembling $<...
	$(CC) $(CFLAGS) -o $@ $<

clean:
	-@$(RM) $(OBJS) $(OBJS:.o=.lst)
	-@$(RM) $(ELF) $(HEX) $(BIN) $(LST) $(VLG) $(MAP)
