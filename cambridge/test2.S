    .section .text
    .option arch, +zcheripurecap
    .globl _start
_start:
    gctag t1, ca0       # Load default data capability into ca0

    # Load a capability from memory using ca0
    LC ca1, 0(ca0)        # Load capability from offset 0 in ca0

    # Store a capability to memory
    SC ca1, 16(ca0)       # Store ca1 at offset 16 from ca0

    # Load and store integers via ca0
    lw t0, 32(ca0)        # Load integer word
    sw t0, 36(ca0)        # Store integer word

loop:
    j loop                # Infinite loop
