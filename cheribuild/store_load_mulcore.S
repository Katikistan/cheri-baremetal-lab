.global _start 
.section .data
.align 3 
buffer:
    .space 8 

.section .text
_start:
    # hart ID (0 or 1)
    csrr a0, mhartid       

    li t0, 0
    beq a0, t0, core0
    j core1

core0: # Create capability and store
    lui      a0, %hi(buffer)
    addi     a0, a0, %lo(buffer)
    
    # Derive capability 
    cspecialrw ct0, pcc, c0     
    csetaddr ct0, ct0, a0    
    csetbounds ct0, ct0, 8   

    # Derive cap to be stored
    cspecialrw ct1, pcc, c0      
    csetbounds ct1, ct1, 8   
    # store ct1 with ct0
    sc.cap ct1, 0(ct0)
    ebreak   

core1: # load capability
    lui      a0, %hi(buffer)
    addi     a0, a0, %lo(buffer)

    cspecialrw ct0, pcc, c0     
    csetaddr ct0, ct0, a0    
    csetbounds ct0, ct0, 8   
    
    cgettag a0, ct1
    lc.cap ct1, 0(ct0)
    cgettag a1, ct1
    ebreak                 