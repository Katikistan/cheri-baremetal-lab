.globl _start
.option capmode
.section .text
_start:
    # Derive from root cap PCC
    cspecialrw ct0, pcc, c0    
    # Setting bounds
    csetbounds ct0, ct0, 8
    # get permissions 
    cgetperm   a1, ct0 
    ebreak