.global _start
.section .data
# 2^3 = 8 bytes (64 bits) 
.align 3
buffer:
    .space 8
.section .text
_start:
    # Get address of buffer
    lui      a0, %hi(buffer)        
    addi     a0, a0, %lo(buffer)   

    # Derive capability 
    cspecialrw ct0, pcc, c0     
    csetaddr   ct0, ct0, a0    
    csetbounds ct0, ct0, 8     

    # Create a capability to store
    li         a1, 4        
    csetoffset ct1, ct0, a1     
    csetbounds ct1, ct1, 4    
    
    # Clear permissions and tag
    li         a3, 0x0
    candperm   ct0, ct0, a3 
    ccleartag  ct0, ct0

    csc        ct1, 0(ct0)          
    clc        ct2, 0(ct0)
    cgettag    a0, ct0 
    cgettag    a1, ct1
    cgettag    a2, ct2              