.global _start # entry point
.section .data
.align 5 # align shared cap to 2^5=32-byte boundary.
buffer:
    .space 32 # enough space for one capabiltiy

.section .text
_start:
    # Step 1: Create valid capability to `buffer`
    lui     a0, %hi(buffer)
    addi    a0, a0, %lo(buffer)
    cspecialrw c1, 1, ct0
    csetoffset c1, c1, a0

    # Step 2: Invalidate the capability by clearing its tag
    #ccleartag c1, c1
    cgettag t2, c1
    # Step 3: Try to store character 'A' (0x41) using invalid capability
    li      a1, 0x41
    sb.cap     a1, 0(c1)            # Should be ignored/fault

    # Step 4: Try to load from invalid capability
    lb.cap     a2, 0(c1)            # Should return 0 or cause fault

    # Step 5: Check tag bit of capability using GCTAG
    cgettag   a3, c1               # a3 = tag bit (0 = invalid, 1 = valid)

    # Print loaded character
    li      t1, 0x10000000
    csetoffset c1, c1, t1
    sb.cap      a2, 0(c1)            # UART: print loaded char

    # Print space
    li      t2, 0x20
    sb.cap      t2, 0(c1)

    # Convert tag bit (0 or 1) to ASCII '0' or '1'
    addi    a3, a3, 0x30
    sb.cap      a3, 0(c1)            # UART: print tag bit

    # Infinite loop
1:  j       1b
