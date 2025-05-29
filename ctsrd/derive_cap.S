.globl _start
.section .text
_start:
    # Derive from root cap PCC
    cspecialrw ct0, pcc, c0    
    # Setting bounds
    csetbounds ct0, ct0, 8

    cgetperm   a1, ct0 
    

