.global _start
.option arch, +zcheripurecap
.section .data
.align 5   # 32-byte aligned
buffer:
    .space 32   

.section .text
_start:
    lui      t0, %hi(buffer)
    addi     t0, t0, %lo(buffer)

    auipc    ct1, 0
    scaddr   ct1, ct1, t0         
    scbndsi  ct1, ct1, 32         

    # Copy capability
    cmv    ct2, ct1   
    # Store at buffer          
    sc       ct2, 0(ct1) 
    # Load from buffer         
    lc       ct3, 0(ct1)          

