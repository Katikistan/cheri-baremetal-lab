.attribute arch, "rv32gcxcheri" # general, compressed, cheri extension
.global _start # entry point
.option capmode #c0-c15 are cap registers, use csc, clc, setbounds etc.

.section .data
.align 5 # align shared cap to 2^5=32-byte boundary.
shared_cap:
    .space 32 # enough space for one capabiltiy

.section .text
_start:
    csrr a0, mhartid       # a0 = hart ID (0 or 1)

    li t0, 0
    beq a0, t0, core0
    j core1

core0:
    # Core 0: create capability and store
    lui      t0, %hi(shared_cap)
    addi     t0, t0, %lo(shared_cap)
    csetoffset ct1, ddc, t0       # Set the offset of DDC to get base+offset
    cbuildcap ct1, ddc, ct1       # Construct a new capability from DDC and offset
    csetbounds ct1, ct1, 32
    sc.cap ct1, 0(ct1)
    ebreak                 

core1:
    # Core 0: load capability
    lui      t0, %hi(shared_cap)
    addi     t0, t0, %lo(shared_cap)
    cfromptr ct1, ddc, t0
    csetbounds ct1, ct1, 32
    lc.cap ct2, 0(ct1)
    cgettag t1, ct2
    ebreak                 
