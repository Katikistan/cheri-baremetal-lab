.globl _start
.option arch, +zcheripurecap
.section .text
_start:
    # Derive from root cap PCC
    auipc ct0, 0    
    # set bounds     
    scbnds ct0, ct0, 8   
    # get permissions 
    gcperm a1, ct0
    ebreak