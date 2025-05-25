.global _start 
.section .data
.align 5 # align to 32-byte boundary.
buffer:
    .space 32 # space for one capabiltiy

.section .text
_start:
    # Derive capability
    lui     a0, %hi(buffer)
    addi    a0, a0, %lo(buffer)
    cspecialrw c1, 1, ct0 # get root cap (DDC)
    csetoffset c1, c1, a0  

    cgettag t2, c1
    # Invalidate the capability by clearing its tag
    # ccleartag c1, c1 
    
    # Try to store character 'A' (0x41) 
    li      a1, 0x41
    sb.cap     a1, 0(c1)            # store: Should be ignored/fault if tag cleared

    # Try to load from capability
    lb.cap     a2, 0(c1)            

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


