TARGET ?= hello
SRC = $(HOME)/cheri/$(TARGET).S
CORES ?= 1
MODE ?= kernel      # 'kernel' or 'bios'
CHERI ?= 1          # 1 = CHERI, 0 = non-CHERI

SDK := $(HOME)/cheri/output/sdk/bin
CLANG := $(SDK)/clang
LD := $(SDK)/ld.lld
OBJCOPY := $(SDK)/llvm-objcopy
GDB := $(SDK)/gdb

OBJ := $(TARGET).o
ELF := $(TARGET).elf
BIN := $(TARGET).bin
LINKER := $(HOME)/cheri/linker.ld

ifeq ($(CHERI),1) # if cheri use cheri qemu and cheri arc, else dont
  QEMU := $(SDK)/qemu-system-riscv32cheri
  ARCH_FLAGS := -target riscv32-unknown-freebsd -march=rv32ixcheri -mabi=il32pc64
else
  QEMU := $(SDK)/qemu-system-riscv32
  ARCH_FLAGS := -target riscv32-unknown-elf -march=rv32i -mabi=ilp32
endif

CFLAGS := $(ARCH_FLAGS) -nostdlib -ffreestanding -fno-pic -g

QEMU_BASE_FLAGS := -machine virt -cpu rv32 -m 256M -smp $(CORES) -nographic -S -s

ifeq ($(MODE),bios)
  QEMU_FLAGS := $(QEMU_BASE_FLAGS) -bios $(BIN) 
else
  QEMU_FLAGS := $(QEMU_BASE_FLAGS) -bios none -kernel $(ELF)
endif

.PHONY: build run gdb clean

build:
	$(CLANG) $(CFLAGS) -c $(SRC) -o $(OBJ)
	$(LD) -T $(LINKER) -o $(ELF) $(OBJ)
	$(OBJCOPY) -O binary $(ELF) $(BIN)

run: build
	$(QEMU) $(QEMU_FLAGS)

gdb: $(ELF)
	$(GDB) $(ELF)

clean:
	rm -f *.o *.elf *.bin
