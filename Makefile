
CROSS=mipsel-none-elf-

CC=${CROSS}gcc
AS=${CROSS}as
LD=${CROSS}gcc
AR=${CROSS}ar
OBJCOPY=${CROSS}objcopy
OBJDUMP=${CROSS}objdump
SIZE=${CROSS}size



TARGET = sample

SRCS = sample.s

HEX		= $(TARGET).hex
BIN		= $(TARGET).bin
ELF		= $(TARGET).elf
MAP		= $(TARGET).map
LST		= $(TARGET).lst

OBJS	:= $(SRCS)
OBJS	:= $(OBJS:.c=.o)
OBJS	:= $(OBJS:.s=.o)
OBJS	:= $(OBJS:.S=.o)


# C options
CFLAGS	= -c -g -Wall -EL -mips1

# LD options
LDFLAGS	= -Wl,-Map=$(MAP) -static -nostdlib
# -T supply your own linker script
LDFLAGS	+= -T $(TARGET).ld

.SILENT :

.PHONY: all start


all: start $(ELF) $(HEX) $(BIN) $(LST) $(OK)

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

$(ELF):	$(OBJS)
	@echo --- linking...
	$(LD) $(OBJS) $(LDFLAGS) -o "$(ELF)"
	
%.o: %.c
	@echo --- compiling $<...
	$(CC) $(CFLAGS) -o $@ $<

%.o: %.S
	@echo --- assembling $<...
	$(CC) $(CFLAGS) -o $@ $<

%.o: %.s
	@echo --- assembling $<...
	$(CC) $(CFLAGS) -o $@ $<

clean:
	-@$(RM) $(OBJS) $(OBJS:.o=.lst)
	-@$(RM) $(ELF) $(HEX) $(BIN) $(LST) $(MAP)
