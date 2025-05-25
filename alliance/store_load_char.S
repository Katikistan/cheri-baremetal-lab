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

    # Store char 'A'     
    li       a1, 0x41             
    sb       a1, 0(ct0) 

    # Load with ct0          
    lb       a2, 0(ct0)
    
    # UART address
    li       a3, 0x10000000   

    # Making print cap
    auipc    ct1, 0
    scaddr   ct1, ct1, a3
    scbndsi  ct1, ct1, 8   

    # Print loaded character
    sb       a2, 0(ct1)   

    # Print space
    li      a4, 0x20
    sb      a4, 0(ct1)

    # Convert tag bit (0 or 1) 
    # ASCII '0' (0x30) or '1' (0x31)
    gctag a5, ct1 
    addi    a5, a5, 0x30
    # Print tag bit
    sb      a5, 0(ct1)            
