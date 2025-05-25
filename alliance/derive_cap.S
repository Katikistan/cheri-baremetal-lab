# Derive a capability 
.globl _start
.option arch, +zcheripurecap
.section .text
_start:
    # Derive from root cap PCC
    auipc ct0, 0    
    # set bounds     
    scbnds ct0, ct0, 32   
    # set get permissions
    li a0, 0x18 
    acperm ct0, ct0, a0   
    gcperm a1, ct0

