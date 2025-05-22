# Derive a capability 
.globl _start
.option arch, +zcheripurecap
.section .text
_start:
    # Derive from root cap DDC
    auipc ct0, 0          # load pcc into ct0 with zero offset   
    gctag x1, c1   
    gcperm a1, ct0        # cgetperm  
    scbnds ct0, ct0, 32   # csetbounds
    li a1, 0x18         # removing bit 0 and 1 (global and execute permission)

    acperm ct0, ct0, a1   # candperm, strip permission
    gcperm a3, ct0        # cgetperm

