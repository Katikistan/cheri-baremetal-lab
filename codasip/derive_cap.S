# Derive a capability 
.globl _start
.option arch, +zcheripurecap
.section .text
_start:
    # Derive from root cap DDC
    cspecialrw ct0, ddc, c0      
    csetbounds ct0, ct0, 32  
    li a1, 0xffc # removing bit 0 and 1 (global and execute permission)
    candperm ct0, ct0, a1
    cgetperm a2, ct0 

