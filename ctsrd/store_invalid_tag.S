.global _start 
.section .data
# 2^4 = 16 byte (128 bits)
.align 4 
buffer:
    .space 16  

.section .text
_start:
    # Get address of buffer
    lui      a0, %hi(buffer)        
    addi     a0, a0, %lo(buffer)   
    
    # Derive capability to buffer
    cspecialrw ct0, pcc, c0
    csetaddr ct0, ct0, a0
    csetbounds ct0, ct0, 16
    # should clear tag
    csetbounds ct0, ct0, 32

    
    # ASCII 'A'
    li      a1, 0x41
    sb.cap     a1, 0(ct0)
    lb.cap     a2, 0(ct0)            