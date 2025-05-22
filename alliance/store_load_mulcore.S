.global _start # entry point
.option arch, +zcheripurecap
.section .data
.align 5 # align shared cap to 2^5=32-byte boundary.
buffer:
    .space 32 # enough space for one capabiltiy

.section .text
_start:
    csrr a0, mhartid       # a0 = hart ID (0 or 1)
    li t0, 0
    beq a0, t0, core0
    j core1

core0:
    # Core 0: create capability and store
    lui      t1, %hi(buffer)        # Get high 20 bits
    addi     t1, t1, %lo(buffer)    # Add low 12 bits

    # Derive a capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, t1         # Set ct1 address to buffer
    scbndsi  ct0, ct0, 32         # Optionally bound to 64 bytes
    
    # Copy capability
    cmv    ct1, ct0    

    # Create a capability to store
    caddi ct1, ct1, 16
    scbndsi  ct1, ct1, 16    
    
    sc ct1, 0(ct0)     # Store the capabiltiy
    ebreak     # switch to other thread            

core1:
    # Core 0: create capability and store
    lui      t1, %hi(buffer)        # Get high 20 bits
    addi     t1, t1, %lo(buffer)    # Add low 12 bits

    # Derive a capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, t1         # Set ct1 address to buffer
    scbndsi  ct0, ct0, 32         # Optionally bound to 64 bytes
    


    lc  ct2, 0(ct0) # load cap gotten from other core
    cgettag t1, ct2
    ebreak                 
