.global _start 
.option capmode
.section .data
# 2^4 = 16 byte (128 bits)
.align 4 
buffer:
    .space 16  
.section .text
_start:
    auipcc  ca0, %pcrel_hi(buffer)
    addi   a0, a0, %lo(buffer)
    # hart ID (0 or 1)
    csrr a1, mhartid       
    li   t0, 0
    beq  a1, t0, core0
    j core1

core0: # Create capability and store

    # Derive a capability to buffer
    cspecialrw ct0, pcc, c0     
    csetaddr   ct0, ct0, a0    
    csetbounds ct0, ct0, 16   

    # Derive cap to be stored
    cspecialrw ct1, pcc, c0      
    csetbounds ct1, ct1, 16 
    # Workaround to csc, use sc.cap
    sc.cap     ct1, 0(ct0) # Store the capabiltiy
    ebreak # switch to other thread in gdb  
  
core1: # load capability
     # Derive a capability to load from buffer
    cspecialrw ct0, pcc, c0     
    csetaddr   ct0, ct0, a0    
    csetbounds ct0, ct0, 16   
    
    cgettag    a0, ct1
    # Workaround to clc, use lc.cap
    lc.cap     ct1, 0(ct0)
    cgettag    a1, ct1
    ebreak                 