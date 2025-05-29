.global _start # entry point
.option arch, +zcheripurecap
.section .data
# 2^4 = 16 byte (128 bits)
.align 4 
buffer:
    .space 16  
.section .text
_start:
    csrr a0, mhartid      
    li t0, 0
    beq a0, t0, core0
    j core1

core0:
    # Core 0: create capability and store
    auipc  ca0, %pcrel_hi(buffer)
    addi   a0, a0, %lo(buffer)

    # Derive a capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, a0
    scbndsi  ct0, ct0, 16         
    
    # Copy capability
    cmv    ct1, ct0    

    # Create a capability to store
    caddi ct1, ct1, 4
    scbndsi  ct1, ct1, 4   
    
    sc ct1, 0(ct0)     # Store the capabiltiy
    ebreak     # switch to other thread            

core1:
    # Core 0: create capability and store
    lui      a0, %hi(buffer)        # Get high 20 bits
    addi     a0, a0, %lo(buffer)    # Add low 12 bits

    # Derive a capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, a0     
    scbndsi  ct0, ct0, 8        
    
    gctag a0, ct1
    lc  ct1, 0(ct0) 
    gctag a1, ct1
    ebreak                 
