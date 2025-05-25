# Derive a capability 
.globl _start
.option arch, +zcheripurecap
.section .text
_start:
    # Derive from root cap PCC
    auipc ct0, 0  
    # get tag          
    gctag x1, c1   
    # get permissions
    gcperm a1, ct0   
    # set bounds     
    scbnds ct0, ct0, 32   
    li a1, 0x18         
    # set permissions
    acperm ct0, ct0, a1   
    gcperm a3, ct0

