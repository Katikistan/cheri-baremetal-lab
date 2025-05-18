# Cheri Baremetal Lab
This repository contains minimal CHERI-RISCV32 assembly programs and a build system for running and debugging them on bare-metal QEMU. Intended for experimenting with CHERI's capability model. We have tested the CTSRD-CHERI and CHERI-Alliance toolchains 

## Setup
### CTSRD-CHERI Toolchain
To build and run programs, you will need the CHERI toolchain provided via [cheribuild](https://github.com/CTSRD-CHERI/cheribuild).

We use the CHERI versions of QEMU, LLVM, and GDB. Build them with:
```
./cheribuild.py qemu -d
./cheribuild.py llvm -d 
./cheribuild.py gdb-native -d 
```

Note: Cheribuild may have issues on macOS. Tools are installed under `~/cheri`.
### CHERI-Alliance Toolchain
Install required build tools and libraries.
```
sudo apt update
sudo apt install -y build-essential autoconf automake libtool pkg-config clang bison cmake mercurial ninja-build flex texinfo time libglib2.0-dev libpixman-1-dev libarchive-dev libbz2-dev libattr1-dev libcap-ng-dev libexpat1-dev libgmp-dev libncurses-dev bc
```
#### QEMU
Clone the CHERI Alliance QEMU repo:
```
git clone https://github.com/CHERI-Alliance/qemu.git
cd qemu
git checkout codasip-cheri-riscv_v3   
```
Configure, build and install:
```
mkdir build && cd build
../configure --target-list=riscv32cheri-softmmu,riscv64cheri-softmmu --disable-werror
make -j$(nproc)
sudo make install
```
#### LLVM
Clone the CHERI Alliance LLVM repo:
```
git clone https://github.com/CHERI-Alliance/llvm-project.git
cd llvm-project
git checkout codasip-cheri-riscv
```
Configure, build and install:
```
cd llvm-project
mkdir build && cd build
cmake -G Ninja ../llvm \
  -DCMAKE_INSTALL_PREFIX=/opt/codasip-llvm \
  -DLLVM_TARGETS_TO_BUILD="RISCV" \
  -DLLVM_ENABLE_PROJECTS="clang;lld" \
  -DCMAKE_BUILD_TYPE=Release
ninja               
sudo ninja install   
```
make had some issues so we used ninja for llvm, we ended up placing LLVM in /opt/codasip-llvm to verify it was installed correctly.
#### GDB
Clone the CHERI Alliance GDB repo:
```
git clone https://github.com/CHERI-Alliance/gdb.git
cd gdb
git checkout codasip-cheri-riscv
```
Configure, build and install:
```
mkdir build-gdb && cd build-gdb
../configure --target=riscv32-unknown-elf --disable-werror
make -j$(nproc)
sudo make install
```
## Building and Running

Assembly programs should be placed in either `./codasip/` or `./cambridge/`  and should use `*.S`.

The two toolchains use different instructions so we seperated programs written for either one toolchain or the other.

The Makefile provides the following targets:

```bash
make build TARGET=test               # Build a program (CHERI by default, use CHERI=0 for baseline)
make run TARGET=test                 # Build and run a CHERI program in QEMU
make gdb TARGET=test                 # Start GDB with a CHERI-enabled binary
make clean                           # Remove all build artifacts
```

**Optional flag:**

* `CHERI=0`: disables CHERI support for baseline RISC-V32
* `TOOLCHAIN=codasip`: Uses the CHERI-Alliance toolchain

All programs are assembled with CHERI Clang using a custom linker script targeting `0x80000000`.

## GDB Debugging

Start GDB for a target with:

```bash
make gdb TARGET=test
```

In GDB: `target remote :1234`
QEMU runs with `-s` to enable the GDB server on port 1234.

### Useful GDB Commands

```
monitor quit              # Quit QEMU
stepi                     # Step one instruction
info registers            # Display all registers
info reg t0               # Display a specific register
print $ct0                # Show CHERI capability register ct0
disas                     # Disassemble current function
layout asm                # The assembly instructions for the currently executing function
x/8i $pc                  # Show upcoming instructions
info threads              # List all active cores/threads
thread <n>                # Switch to thread/core n
thread apply all info reg # Show registers for all threads

```

## File Structure

* `Makefile`: Build automation for CHERI/non-CHERI and BIOS/kernel modes
* `linker.ld`: Linker script targeting bare-metal memory at `0x80000000`
* `bios.S`: Bootloader used in BIOS mode
* `programs/*.S`: Assembly source files to be tested

## Academic Use

This setup was developed for a computer science bachelor's project at Copenhagen University to explore CHERI's hardware-enforced memory safety. It enables writing and testing CHERI-enabled RISC-V assembly in a minimal bare-metal environment.
