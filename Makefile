TARGET ?= hello
SRC = $(HOME)/cheri/$(TARGET).S
CORES ?= 1
CHERI ?= 1          # 1 = CHERI, 0 = non-CHERI

SDK := $(HOME)/cheri/output/sdk/bin
CLANG := $(SDK)/clang
LD := $(SDK)/ld.lld
OBJCOPY := $(SDK)/llvm-objcopy
GDB := $(SDK)/gdb

OBJ := $(TARGET).o
EXE := $(TARGET)
LINKER := $(HOME)/cheri/linker.ld

ifeq ($(CHERI),1) # if cheri use cheri qemu and cheri arc, else dont
  QEMU := $(SDK)/qemu-system-riscv32cheri
  ARCH_FLAGS := -target riscv32-unknown-freebsd -march=rv32ixcheri -mabi=il32pc64
else
  QEMU := $(SDK)/qemu-system-riscv32
  ARCH_FLAGS := -target riscv32-unknown-elf -march=rv32i -mabi=ilp32
endif

CFLAGS := $(ARCH_FLAGS) -nostdlib -ffreestanding -fno-pic -g

QEMU_BASE_FLAGS := -machine virt -nographic -cpu rv32 -m 256M -smp $(CORES) -bios none -kernel $(EXE) -S -s

.PHONY: build run gdb clean

build:
	$(CLANG) $(CFLAGS) -c $(SRC) -o $(OBJ)
	$(LD) -T $(LINKER) -o $(EXE) $(OBJ)

run: build
	$(QEMU) $(QEMU_FLAGS)

gdb: $(EXE)
	$(GDB) $(EXE)

clean:
	rm -f *.o $(TARGET)
