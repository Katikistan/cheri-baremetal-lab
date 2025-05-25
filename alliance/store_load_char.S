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
    scbndsi  ct1, ct1, 8   
    # ASCII 'A'      
    li       t0, 0x41 
    # store byte 'A' at buffer[0]             
    sb       t0, 0(ct1)           
    lb       t2, 0(ct1)

    # Print loaded character
    li      t1, 0x10000000           # UART address
    csetoffset c1, c1, t1
    sb.cap      a2, 0(c1)            # UART: print loaded char

    # Print space
    li      t2, 0x20
    sb.cap      t2, 0(c1)

    # Convert tag bit (0 or 1) to ASCII '0' (0x30) or '1' (0x31)
    cgettag a3, c1 # get tag
    addi    a3, a3, 0x30
    sb.cap      a3, 0(c1)            # UART: print tag bit
