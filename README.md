# Cheri Baremetal Lab
This repository contains minimal CHERI-RISCV32 assembly programs along with a build system for running and debugging them on a bare-metal QEMU. Inteded for experimenting with CHERI's capability model.

## Setup
To build and run programs, you will need the CHERI toolchain provided via [cheribuild](https://github.com/CTSRD-CHERI/cheribuild)

We make use of the Cheri qemu, llvm and gdb implementations. Follow instructions on cheribuild README. The following commnands was used to build the needed tools:
```bash
./cheribuild.py qemu
./cheribuild.py llvm
./cheribuild.py gdb-native
````

## Building and Running
Assembly programs should be placed in ~/cheri/PROGRAM.S, which will be created when using cheribuild. The Makefile include the following build targets:
```
make PROGRAM=test           # Builds test.elf from ~/cheri/test.S
make run PROGRAM=test       # Runs test.elf in QEMU (default: 1 core, kernel mode)
make run PROGRAM=test CORES=2  # Run with 2 cores
make gdb PROGRAM=test       # Starts GDB on test.elf
make clean                
```
**Optional flags:**
`MODE=bios`: run using -bios

`CHERI=0`: build for baseline RISC-V32 (no CHERI)

Programs are assembled and linked using CHERI Clang and a custom linker script targeting 0x80000000. 

Binaries are run on CHERI-QEMU in bare-metal mode to observe CHERI instruction behavior, such as setting capability bounds, permissions, and triggering faults. 

GDB is used to step through instructions and inspect capability register state.

# gdb
To start gdb:
```
make gdb PROGRAM=test
```
QEMU opens a port at `1234` that we can target with out gdb stub. QEMU has some issues setting the pc to the proper address therefore we set it manually in gdb
```
target remote :1234
set $pc = 0x80000000
stepi # next instruction
info registers
info reg t0
print $ct0
monitor quit # quits QEMU
```

- `Makefile`: Build system supporting CHERI/non-CHERI and BIOS/kernel modes

- `linker.ld`: Bare-metal memory layout for ELF and binary generation

- `*.S`: CHERI assembly programs placed in ~/cheri/

  # For Academic Use
  This setup was developed as part of a computer science bachelor project at Copenhagen University to study CHERI's hardware-enforced memory safety. It provides a platform for testing capability behavior and write simple cheri-enabled assembly programs to be tested.




