.global _start
.option arch, +zcheripurecap
.section .data
buffer:
    .space 1 
.section .text
_start:
    auipc  ca0, %pcrel_hi(buffer)
    addi   a0, a0, %lo(buffer)

    # Derive capability
    auipc    ct0, 0
    # Set ct0 address to buffer
    scaddr   ct0, ct0, a0  
    #restrict bound to fit 1 char
    scbndsi  ct0, ct0, 1   
    # address out of bound
    caddi ct0, ct0, 2 
    
    # Store char 'A'  (should fail) 
    li       a1, 0x41             
    sb       a1, 0(ct0)         
