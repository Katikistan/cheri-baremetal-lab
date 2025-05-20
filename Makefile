TARGET ?= hello
SRC = $(HOME)/cheri-baremetal-lab/$(TARGET).S
CORES ?= 1
TOOLCHAIN ?= codasip

ifeq ($(TOOLCHAIN),codasip)
$(info Using codasip toolchain)
	SDK := /usr/local/bin
	GDB := $(SDK)/riscv32-unknown-elf-gdb
	LLVM_PATH := /opt/codasip-llvm/bin
	CLANG := $(LLVM_PATH)/clang
	LD := $(LLVM_PATH)/ld.lld
	OBJCOPY := $(LLVM_PATH)/llvm-objcopy
	QEMU_BASE_FLAGS := -machine virt -nographic -cpu rv32,Xcheri_purecap=on,cheri_v090=on -m 2G 
else
$(info Using cambridge toolchain)
	SDK := $(HOME)/cheri/output/sdk/bin
	CLANG := $(SDK)/clang
	LD := $(SDK)/ld.lld
	OBJCOPY := $(SDK)/llvm-objcopy
	GDB := $(SDK)/gdb
	QEMU_BASE_FLAGS := -machine virt -nographic -cpu rv32 -m 2G 
endif

LINKER := $(HOME)/cheri-baremetal-lab/linker.ld
OBJ := $(TARGET).o
EXE := $(TARGET).elf

ifeq ($(CHERI),0) 
$(info CHERI not enabled)
  QEMU := $(HOME)/cheri/output/sdk/bin/qemu-system-riscv32
  ARCH_FLAGS := -target riscv32-unknown-elf -march=rv32i -mabi=ilp32
else
$(info CHERI enabled)
  QEMU := $(SDK)/qemu-system-riscv32cheri
  ARCH_FLAGS := -target riscv32-unknown-elf -march=rv32ixcheri -mabi=il32pc64

endif

CFLAGS := $(ARCH_FLAGS) 

QEMU_FLAGS := $(QEMU_BASE_FLAGS) -d instr -smp $(CORES) -bios none -kernel $(EXE) -S -s

.PHONY: build run gdb clean

build:
	$(CLANG) $(CFLAGS) -c $(SRC) -o $(OBJ)
	$(LD) -T linker.ld -o $(EXE) $(OBJ)

run: build
	$(QEMU) $(QEMU_FLAGS)

gdb: $(EXE)
	$(GDB) $(EXE)

clean:
	rm -f *.o *.elf cambridge/*.o cambridge/*.elf codasip/*.o codasip/*.elf


