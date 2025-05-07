    .section .text
    .global _start
    .option capmode
    .option norvc
_start:
    cspecialrw ct0, ddc, c0  # ct0 = DDC
    li t1, 123
    cincoffset ct0, ct0, t1     # ct0.offset += 123

    ebreak
