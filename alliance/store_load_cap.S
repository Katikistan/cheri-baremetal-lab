.global _start
.option arch, +zcheripurecap
.section .data
# 2^4 = 16 byte (128 bits)
.align 4 
buffer:
    .space 16  
.section .text
_start:
    # Get address of buffer
    auipc  ca0, %pcrel_hi(buffer)
    addi   a0, a0, %lo(buffer)
    
    # Derive capability
    auipc    ct0, 0
    scaddr   ct0, ct0, a0         
    scbndsi  ct0, ct0, 16         

    # Copy capability
    cmv      ct1, ct0  
     
    # Store at buffer          
    sc       ct1, 0(ct0) 
    # Load from buffer         
    lc       ct2, 0(ct0)

    gctag    a0, ct0 
    gctag    a1, ct1
    gctag    a2, ct2 
    ebreak