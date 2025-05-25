.global _start
.option arch, +zcheripurecap
.section .data
# 2^3 = 8 bytes (64 bits) 
.align 2
buffer:
    .space 8

.section .text
_start:
    # Get address of buffer
    lui      a0, %hi(buffer)
    addi     a0, a0, %lo(buffer)

    # Derive capability to buffer
    auipc    ct1, 0
    scaddr   ct1, ct1, t0
    scbndsi  ct1, ct1, 8          
    
    li       t0, 0x4
    # Clear load permissions         
    acperm   ct1, ct1, t0  
    # ASCII 'A'
    li       t0, 0x41           
    sb       t0, 0(ct1)   

    # Load with ct0
    lb       t2, 0(ct1)