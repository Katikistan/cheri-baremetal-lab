.global _start
.option capmode 
.section .data
buffer:
    .space 16  
.section .text
_start:
    # Get address of buffer
    auipcc  ca0, %pcrel_hi(buffer)
    addi    a0, a0, %lo(buffer)
    
    # Derive capability to buffer
    cspecialrw ct0, pcc, c0
    csetaddr   ct0, ct0, a0
    csetbounds ct0, ct0, 1

    # should clear tag
    csetbounds ct0, ct0, 2

    # ASCII 'A'
    li         a1, 0x41
    sb.cap     a1, 0(ct0)
    lb.cap     a2, 0(ct0)