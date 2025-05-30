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

    # Derive capability to buffer
    auipc    ct0, 0
    scaddr   ct0, ct0, a0
    scbndsi  ct0, ct0, 1          
    
    # Clear load permissions   
    li       a1, 0x3b        
    acperm   ct0, ct0, a1
    
    # ASCII 'A'
    li       a2, 0x41           
    sb       a2, 0(ct0)   
    # Load with ct0
    lb       a3, 0(ct0)
    ebreak