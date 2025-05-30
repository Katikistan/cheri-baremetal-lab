.global _start 
.option capmode
.section .data
buffer:
    .space 1
.section .text
_start:
    # Get address of buffer
    auipcc  ca0, %pcrel_hi(buffer)
    addi    a0, a0, %lo(buffer)
    
    # Derive capability to buffer
    cspecialrw ct0, pcc, c0
    csetaddr   ct0, ct0, a0
    csetbounds ct0, ct0, 1
    
    # Clear load permissions
    li         a1, 0xfffb
    candperm   ct0, ct0, a1 
    cgetperm a4, ct0

    # ASCII 'A'
    li         a2, 0x41
    sb.cap     a2, 0(ct0)          
    # Load with ct0
    lb.cap     a3, 0(ct0) 
    ebreak           