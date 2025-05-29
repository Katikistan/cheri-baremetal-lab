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

    # Derive capability
    auipc    ct0, 0
    # Set ct0 address to buffer
    scaddr   ct0, ct0, a0  
    # Too small for storing cap
    scbndsi  ct0, ct0, 4        

    # Derive a capability to store
    cmv      ct1, ct0
    
    # Store in buffer              
    sc       ct1, 0(ct0)
    # Load from buffer      
    lc       ct3, 0(ct0)          
