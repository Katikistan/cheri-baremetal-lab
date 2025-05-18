.attribute arch, "rv32gcxcheri" # general, compressed, cheri extension
.global _start # entry point
.option capmode #c0-c15 are cap registers, use csc, clc, setbounds etc.

.section .data
.align 5 # align shared cap to 2^5=32-byte boundary.
shared_cap:
    .space 32 # enough space for one capabiltiy

.section .text
_start:
    # Load address of shared_cap into t0
    lui      t1, %hi(shared_cap)        # Get high 20 bits of address
    addi     t1, t1, %lo(shared_cap)    # Add low 12 bits

    # Derive a capability to shared_cap
    cspecialrw ct0, pcc, c0     # Put ddc into ct0
    csetoffset ct0, ct0, t1     # Set the offset of DDC to get base+offset
    // cbuildcap ct0, pcc, ct0     # Construct a new capability from DDC and offset
    csetbounds ct0, ct0, 32     # Limit bounds

    // li t1, 0x0   
    // candperm ct0, ct0, t1 # clear permissions

    # Create a capability to store
    li       t1, 16         # offset
    csetoffset ct1, ct0, t1   # derived from ct0 but with new offset
    csetbounds ct1, ct1, 16   # restrict to a smaller region
    li a0, 0x0     
    candperm ct0, ct0, t1       # clears permissions

    
    csc ct1, 0(ct0)     # Store the capabiltiy
    clc ct2, 0(ct0)     # Load it back into ct2

    # get tag bit into t1 to check the capability is valid
    cgettag a0, ct0
    cgettag a1, ct1
    cgettag a2, ct2

fail:
    j fail

# Trap handler logs mcause and mtval
.globl trap_handler
trap_handler:
    csrr t1, mcause
    csrr t2, mtval
    .option nocapmode
    la t3, trap_info
    sw t1, 0(t3)
    sw t2, 4(t3)

trap_loop:
    j trap_loop

.section .data
.globl trap_info
trap_info:
    .word 0
    .word 0