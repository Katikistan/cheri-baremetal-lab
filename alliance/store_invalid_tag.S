.global _start
.option arch, +zcheripurecap
.section .data
buffer:
    .space 1  
.section .text
_start:
    # Get address of buffer
    auipc  ca0, %pcrel_hi(buffer)
    addi   a0, a0, %lo(buffer)

    # Create capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, a0
    scbndsi  ct0, ct0, 1 

    # should clear tag
    scbndsi  ct0, ct0, 2
 
    # ASCII 'A'
    li       a1, 0x41  
    sb       a1, 0(ct0)            
    lb       a2, 0(ct0)