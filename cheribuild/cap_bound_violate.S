.global _start
.section .data
# 2^3 = 8 byte (64 bits)
.align 3 
buffer:
    .space 8   
.section .text
_start:
    lui     a0, %hi(buffer)
    addi    a0, a0, %lo(buffer)

    # Derive capability 
    cspecialrw ct0, pcc, c0   
    # Set ct0 address to buffer  
    csetaddr ct0, ct0, a0  
    # Too small for storing cap  
    csetbounds ct0, ct0, 4     

    # Derive a capability to store
    li       a1, 4        
    csetoffset ct1, ct0, a1     
    csetbounds ct1, ct1, 4   

    # Store in buffer              
    sc.cap  ct1, 0(ct0)
    # Load from buffer      
    lc.cap  ct3, 0(ct0)          
