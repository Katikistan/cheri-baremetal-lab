# Derive a capability 
.globl _start
.option arch, +zcheripurecap
.section .text
_start:
    # Derive from root cap DDC
    cmv ct0, pcc          # copys the full pcc into ct0
    scbnds ct0, ct0, 32   # csetbounds
    li a1, 0xffc          # removing bit 0 and 1 (global and execute permission)
    acperm ct0, ct0, a1   # candperm, strip permission
    gcperm a2, ct0        # cgetperm

