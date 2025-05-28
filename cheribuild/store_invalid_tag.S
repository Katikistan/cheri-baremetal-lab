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
    
    # Derive capability to buffer
    cspecialrw ct0, pcc, c0
    csetaddr ct0, ct0, a0
    csetbounds ct0, ct0, 8
    # should clear tag
    csetbounds ct0, ct0, 16

    
    # ASCII 'A'
    li      a1, 0x41
    sb.cap     a1, 0(ct0)
    lb.cap     a2, 0(ct0)            