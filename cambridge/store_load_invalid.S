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
    csetbounds ct0, ct0, 32     # Limit bounds



    # Create a capability to store
    li       t1, 16         # offset
    csetoffset ct1, ct0, t1   # derived from ct0 but with new offset
    csetbounds ct1, ct1, 16   # restrict to a smaller region
    li a0, 0x0     
    candperm ct0, ct0, a0       # clears permissions

    #sc.cap ct1, 0(ct0)     # Store the capabiltiy
    #lc.cap ct2, 0(ct0)     # Load it back into ct2
    csc ct1, 0(ct0)     # Store the capabiltiy
    clc ct2, 0(ct0)     # Load it back into ct2

    # get tag bit into t1 to check the capability is valid
    cgettag a0, ct0
    cgettag a1, ct1
    cgettag a2, ct2

