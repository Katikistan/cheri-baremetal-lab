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

    # Create capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, a0
    scbndsi  ct0, ct0, 16 

    # should clear tag
    scbndsi  ct0, ct0, 32
             
    # Will clear tag
    cbld     ct0, ct1, ct0
    # ASCII 'A'
    li       a1, 0x41  
    sb       a1, 0(ct0)            
    lb       a2, 0(ct0)
