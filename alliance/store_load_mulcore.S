.global _start 
.option arch, +zcheripurecap
.section .data
# 2^4 = 16 byte (128 bits)
.align 4 
buffer:
    .space 16  
.section .text
_start:
    auipc  ca0, %pcrel_hi(buffer)
    addi   a0, a0, %lo(buffer)
    # hart ID (0 or 1)
    csrr a1, mhartid      
    li t1, 0
    beq a1, t1, core0
    j core1

core0: # Create capability and store

    # Derive a capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, a0
    scbndsi  ct0, ct0, 16         
    
    # Copy capability to be stored
    cmv    ct1, ct0    
    caddi ct1, ct1, 4
    scbndsi  ct1, ct1, 4   
    sc ct1, 0(ct0)  # Store the capabiltiy
    ebreak # switch to other thread in gdb          

core1:
    # Derive a capability to load from buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, a0     
    scbndsi  ct0, ct0, 16        
    
    
    gctag a0, ct1
    lc  ct1, 0(ct0) 
    gctag a1, ct1
    ebreak                 