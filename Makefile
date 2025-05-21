TARGET ?= hello
SRC = $(HOME)/cheri-baremetal-lab/$(TARGET).S
CORES ?= 1
TOOLCHAIN ?= alliance

ifeq ($(TOOLCHAIN),alliance)
$(info Using CHERI-Alliance toolchain)
	SDK := /usr/local/bin
	GDB := $(SDK)/riscv32-unknown-elf-gdb
	LLVM_PATH := /opt/codasip-llvm/bin
	CLANG := $(LLVM_PATH)/clang
	LD := $(LLVM_PATH)/ld.lld
	DUMP := $(LLVM_PATH)/llvm-objdump
	OBJCOPY := $(LLVM_PATH)/llvm-objcopy
	QEMU_BASE_FLAGS := -machine virt -nographic -cpu rv32,Xcheri_purecap=on,cheri_v090=on -m 2G 
else
$(info Using cheribuild toolchain)
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

CFLAGS := $(ARCH_FLAGS) -g

QEMU_FLAGS := $(QEMU_BASE_FLAGS) -d instr -smp $(CORES) -bios none -kernel $(EXE) -S -s 

.PHONY: build run gdb clean


build:
	$(CLANG) $(CFLAGS) -c $(SRC) -o $(OBJ)
	$(LD) -T linker.ld -o $(EXE) $(OBJ)
	
dissamble: 
	$(DUMP) -d $(EXE) > $(TARGET)_disassembly.txt 2>&1

run: build dissamble
	$(QEMU) $(QEMU_FLAGS) > $(TARGET)_qemu_output.txt 2>&1

gdb: $(EXE)
	$(GDB) $(EXE) -ex "set logging file $(TARGET)_gdb_log.txt" \
	-ex "set logging overwrite on" \
	-ex "set logging debugredirect on" \
	-ex "set logging enabled on" \
	-ex "target remote :1234"

clean:
	rm -f *.o *.elf cambridge/*.o cambridge/*.elf alliance/*.o alliance/*.elf alliance/*.txt


