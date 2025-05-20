.global _start # entry point

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
    cspecialrw ct0, ddc, c0     
    csetoffset ct0, ct0, t1     
    csetbounds ct0, ct0, 32     

    # Create a capability to store
    li       t1, 16         # offset
    csetoffset ct1, ct0, t1   
    csetbounds ct1, ct1, 16  
    li a0, 0x0     
    
    sc.cap ct1, 0(ct0)     # Store the capabiltiy
    ebreak     # switch to other thread            

core1:
    # Core 0: create capability and store
    lui      t1, %hi(buffer)        # Get high 20 bits
    addi     t1, t1, %lo(buffer)    # Add low 12 bits

    # Derive a capability to buffer
    cspecialrw ct0, ddc, c0     
    csetoffset ct0, ct0, t1     
    csetbounds ct0, ct0, 32     

    lc.cap ct2, 0(ct0) # load cap gotten from other core
    cgettag t1, ct2
    ebreak                 
