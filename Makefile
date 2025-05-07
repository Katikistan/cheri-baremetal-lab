TARGET ?= hello
SRC = $(HOME)/cheri/$(TARGET).S
CORES ?= 1
MODE ?= kernel  # or 'bios'

SDK := $(HOME)/cheri/output/sdk/bin
CLANG := $(SDK)/clang
LD := $(SDK)/ld.lld
OBJCOPY := $(SDK)/llvm-objcopy
QEMU := $(SDK)/qemu-system-riscv32cheri
GDB := $(SDK)/gdb

OBJ := $(TARGET).o
ELF := $(TARGET).elf
BIN := $(TARGET).bin
LINKER := $(HOME)/cheri/linker.ld

CFLAGS := -target riscv32-unknown-freebsd \
          -march=rv32ixcheri -mabi=il32pc64 \
          -nostdlib -ffreestanding -fno-pic -g

QEMU_COMMON_FLAGS := -machine virt -cpu rv32 -m 256M -smp $(CORES) -nographic -S -s

ifeq ($(MODE),bios)
  QEMU_FLAGS := $(QEMU_COMMON_FLAGS) -bios $(BIN)
else
  QEMU_FLAGS := $(QEMU_COMMON_FLAGS) -bios none -kernel $(ELF)
endif

.PHONY: build run gdb clean

build: $(ELF) $(if $(filter bios,$(MODE)),$(BIN))

$(OBJ): $(SRC)
	$(CLANG) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJ) $(LINKER)
	$(LD) -T $(LINKER) -o $@ $<

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

run: build
	$(QEMU) $(QEMU_FLAGS)

gdb: $(ELF)
	$(GDB) $(ELF)

clean:
	rm -f *.o *.elf *.bin
