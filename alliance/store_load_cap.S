.global _start
.option arch, +zcheripurecap
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
    auipc    ct0, 0
    scaddr   ct0, ct0, a0         
    scbndsi  ct0, ct0, 8         

    # Copy capability
    cmv      ct1, ct0   
    # Store at buffer          
    sc       ct1, 0(ct0) 
    # Load from buffer         
    lc       ct2, 0(ct0)
    gctag    a0, ct0 
    gctag    a1, ct1
    gctag    a2, ct2 