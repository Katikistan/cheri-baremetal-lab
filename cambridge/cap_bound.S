    .section .text
    .global _start
    .option capmode


.section .data
.align 5                       # 32-byte aligned
shared_cap:
    .space 64                      # 64 bytes, but bounds will be limited to 32

.section .text
_start:
    # 1. Create a capability to shared_cap
    lui      t0, %hi(shared_cap)
    addi     t0, t0, %lo(shared_cap)
    cfromptr ct0, ddc, t0

    # 2. Limit bounds to 32 bytes
    csetbounds ct0, ct0, 32

    # 3. Set an out-of-bounds offset
    li       t1, 42                 # Offset beyond the 32-byte limit
    cincoffset ct1, ct0, t1        # ct1 = ct0 + 40

    # 4. Try to load from out-of-bounds address (should fault)
    csc      ct1, 0(ct1)     # Store the capabiltiy
    clc      ct2, 0(ct1)           # Attempt to load a capability
    cgettag a0, ct0
    cgettag a1, ct1
    cgettag a2, ct2
    
    ebreak
fail:
    j fail
