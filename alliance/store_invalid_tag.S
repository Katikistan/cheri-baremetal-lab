.global _start
.option arch, +zcheripurecap
.section .data
.align 2
buffer:
    .space 8

.section .text
_start:
    # Get address of buffer
    lui      t0, %hi(buffer)
    addi     t0, t0, %lo(buffer)

    # Create capability to buffer
    auipc    ct1, 0
    scaddr   ct1, ct1, t0
    scbndsi  ct1, ct1, 8          # bound it to 64 bytes

    cbld     ct1, ct2, ct1

    li       t0, 0x41              # ASCII 'A'
    sb       t0, 0(ct1)            # store byte 'A' at buffer[0]
    lb       t2, 0(ct1)
