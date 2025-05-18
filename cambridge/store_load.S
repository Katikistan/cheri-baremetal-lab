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
    csetoffset ct0, ct0, t1     # Set the offset of pcc to get base+offset
    cbuildcap ct0, pcc, ct0     # Construct a new capability from DDC and offset
    csetbounds ct0, ct0, 32     # Limit bounds
    cgettag a0, ct0
    cgetbase a1, ct0

    # Create a capability to store
    li       t1, 16         # offset for demonstration
    csetoffset ct1, ct0, t1   # derived from ct0 but with new offset
    csetbounds ct1, ct1, 16   # restrict it to a smaller region
    cgettag a0, ct1
    cgetbase a1, ct1

    csc ct1, 0(ct0)     # Store the capabiltiy
    clc ct2, 0(ct0)     # Load it back into ct2

    # get tag bit into t1 to check the capability is valid
    cgettag t1, ct2
    ebreak
