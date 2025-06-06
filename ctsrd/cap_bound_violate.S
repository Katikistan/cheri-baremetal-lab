.global _start
.option capmode
.section .data
buffer:
    .space 1  
.section .text
_start:
    auipcc  ca0, %pcrel_hi(buffer)
    addi   a0, a0, %lo(buffer)
    
    # Derive capability 
    cspecialrw ct0, pcc, c0   
    # Set ct0 address to buffer  
    csetaddr ct0, ct0, a0  
    #restrict bound to fit 1 char
    csetbounds ct0, ct0, 1
    # offset out of bound
    cincoffsetimm ct0, ct0, 2    

    # Store char 'A'  (should fail) 
    li       a1, 0x41             
    sb.cap       a1, 0(ct0)         
