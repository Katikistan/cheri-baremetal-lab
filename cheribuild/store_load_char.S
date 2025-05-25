.global _start 
.section .data
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
    csetaddr ct0, ct0, a0
    csetbounds ct0, ct0, 8
    
    # Store char 'A' 
    li      a1, 0x41
    sb.cap     a1, 0(ct0)          

    # Load with ct0
    lb.cap     a2, 0(ct0)            

    # UART address
    li      a3, 0x10000000   

    # Making print cap
    cspecialrw ct1, pcc, c0
    csetaddr ct1, ct1, a3
    csetbounds ct1, ct1, 8

    # print loaded char
    sb.cap      a2, 0(ct1)

    # Print a space
    li      a4, 0x20
    sb.cap      a4, 0(ct1)

    # Convert tag bit (0 or 1) 
    # ASCII '0' (0x30) or '1' (0x31)
    cgettag a5, ct1 
    addi    a5, a5, 0x30
    # Print tag bit
    sb.cap      a5, 0(ct1)            