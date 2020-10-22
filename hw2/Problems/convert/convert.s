.global convert
.type matrix_mul, %function

.align 2
# int convert(char *);
convert:

    # insert your code here

    
    addi t0, x0, 43   #positive
    addi t1, x0, 45   #negative
    addi t2, x0, 48   #ASCII of 0
    addi t3, x0, 58   #ASCII of 9
    addi t6, x0, 0    #ASCII of end
    
    addi t5, x0, 0    #loop idx




    Loop:
        add a2, a0, t5
        lb t4, 0(a2)
        beq t4, t6, Exit
        #beq t4,  t0, Pos
        #bne t4, t0, Neg
        bge t4, t3, Cha
        addi t5, t5, 1
        beq x0, x0, Loop    


    Cha:
        addi a0, x0, -1
        beq x0, x0, Exit


    Pos:
        addi a0, x0, 1
        beq x0, x0, Exit

    Neg:
        addi a0, x0, 0
        beq x0, x0, Exit


    Exit:
        
    

    
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    
    ret

