# Derive a capability 
.globl _start
.option arch, +zcheripurecap
.section .text
_start:
    # Derive from root cap DDC
    csrrw ct0, ddc, c0    # cspecialrw  
    scbnds ct0, ct0, 32   # csetbounds
    li a1, 0xffc # removing bit 0 and 1 (global and execute permission)
    acperm ct0, ct0, a1   # candperm
    gcperm a2, ct0        # cgetperm

