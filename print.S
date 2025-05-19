    .section .text
    .globl _start

_start:
    .option nocapmode
    li t0, 0x10000000     # UART base address
    li t1, 0x41           # ASCII 'A'
    sb t1, 0(t0)          # Print

hang:
    j hang                
