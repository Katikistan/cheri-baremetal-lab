# Cheri Baremetal Lab
This repository contains minimal CHERI-RISCV32 assembly programs along with a build system for running and debugging them on a bare-metal QEMU. Inteded for experimenting with CHERI's capability model.

## Setup
To build and run programs, you will need the CHERI toolchain provided via [cheribuild](https://github.com/CTSRD-CHERI/cheribuild)

We make use of the Cheri qemu, llvm and gdb implementations. Follow instructions on cheribuild README. The following commnands was used to build the needed tools:
```bash
./cheribuild.py qemu -d
./cheribuild.py llvm -d 
./cheribuild.py gdb-native -d 
````
Cheribuild had some issues building on mac. 

## Building and Running
Assembly programs should be placed in `~/cheri/PROGRAM.S`, the cheri folder will be created when using cheribuild. 

**After cloning this repo move Makefile and linker script into `~/cheri`**

The Makefile include the following build targets:
```
make build TARGET=test               # CHERI build
make build CHERI=0 TARGET=test       # Non-CHERI build
make run                             # CHERI, kernel mode
make run MODE=bios CHERI=0           # Non-CHERI, BIOS mode
make gdb TARGET=test                 
make clean                
```
**Optional flags:**
`MODE=bios`: run using -bios

`CHERI=0`: build for baseline RISC-V32 (no CHERI)

Programs are assembled and linked using CHERI Clang and a custom linker script targeting 0x80000000. 

Binaries are run on CHERI-QEMU in bare-metal mode to observe CHERI instruction behavior, such as setting capability bounds, permissions, and triggering faults. 

GDB is used to step through instructions and inspect capability register state.

## gdb
To start gdb:
```
make gdb PROGRAM=test
```
Launching QEMU with the -s makes QEMU start a GDB server listening on TCP port 1234 on localhost. Use `target remote :1234` to connect to QEMU using gdb. QEMU has some issues setting the PC to the proper address therefore we set it manually in gdb.
```
target remote :1234 # connect to QEMU
set $pc = 0x80000000 # set PC to where instructions start
stepi # next instruction
info registers # gives info on all registers
info reg t0 # info on given register
print $ct0 # prints the value of the CHERI capability register ct0
monitor quit # quits QEMU
```
## Included files
- `Makefile`: Build system supporting CHERI/non-CHERI and BIOS/kernel modes

- `linker.ld`: Bare-metal memory layout for ELF and binary generation

- `*.S`: CHERI assembly programs placed in ~/cheri/

## Academic Use
This setup was developed as part of a computer science bachelor project at Copenhagen University to study CHERI's hardware-enforced memory safety. It provides a platform for testing capability behavior and write simple cheri-enabled assembly programs to be tested on bare-metal QEMU.




