.global _start
.option .capmode
.section .data
# 2^4 = 16 byte (128 bits)
.align 4 
buffer:
    .space 16  
.section .text
_start:
    # Get address of buffer
    auipcc  ca0, %pcrel_hi(buffer)
    addi    a0, a0, %lo(buffer)

    # Derive capability 
    cspecialrw ct0, pcc, c0     
    csetaddr   ct0, ct0, a0    
    csetbounds ct0, ct0, 16     

    # Derive a capability to store
    li         a1, 4        
    csetoffset ct1, ct0, a1  
    # restrict bounds   
    csetbounds ct1, ct1, 4    

    csc        ct1, 0(ct0)          
    clc        ct2, 0(ct0)
    cgettag    a0, ct0 
    cgettag    a1, ct1
    cgettag    a2, ct2 
    ebreak             