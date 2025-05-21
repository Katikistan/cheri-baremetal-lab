.global _start
.option arch, +zcheripurecap
.section .data
.align 5 # align buffer to 2^5=32-byte boundary.
buffer:
    .space 32 # space for one capabiltiy

.section .text
_start:
    # Load address of buffer into t0
    lui      t1, %hi(buffer)        # Get high 20 bits of address
    addi     t1, t1, %lo(buffer)    # Add low 12 bits

    # Derive a capability from pcc
    cspecialrw ct0, pcc, c0     
    csetoffset ct0, ct0, t1     
    csetbounds ct0, ct0, 32     

    # Create a capability to store
    li       t1, 16         
    csetoffset ct1, ct0, t1     # set ct0 offset and save as new cap in ct1  
    csetbounds ct1, ct1, 16     # restrict bounds
    li a0, 0x0                  # 0 bit mask to clear permissions
    candperm ct0, ct0, a0       # clears permissions

    sc.cap ct1, 0(ct0)          # should fail   
    lc.cap ct2, 0(ct0)          

    # get tag bits to check the capability is valid
    cgettag a0, ct0
    cgettag a1, ct1
    cgettag a2, ct2

