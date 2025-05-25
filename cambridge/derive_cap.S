# Derive a capability 
.globl _start
.section .text
_start:
    # Derive from root cap PCC
    cspecialrw ct0, pcc, c0    

    csetbounds ct0, ct0, 32  

    li a1, 0xffc 
    candperm ct0, ct0, a1
    
    cgetperm a2, ct0 

