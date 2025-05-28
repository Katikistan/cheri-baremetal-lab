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
    lui      a0, %hi(buffer)
    addi     a0, a0, %lo(buffer)

    # Derive capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, a0
    scbndsi  ct0, ct0, 16          
    
    li       a1, 
    # Clear load permissions         
    acperm   ct0, ct0, a1
    # ASCII 'A'
    li       a2, 0x41           
    sb       a2, 0(ct0)   

    # Load with ct0
    lb       a3, 0(ct0)