.global _start
.option arch, +zcheripurecap
.section .data
.align 5   # 32-byte aligned
buffer:
    .space 32   

.section .text
_start:
lui      t0, %hi(buffer)
addi     t0, t0, %lo(buffer)

auipc    ct1, 0
scaddr   ct1, ct1, t0         # Set ct1 address to buffer
scbndsi  ct1, ct1, 4        

cmv    ct2, ct1             # Copy capability
sc       ct2, 0(ct1)          # Store at buffer
lc       ct3, 0(ct1)          # Load from buffer
