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
    
    addi a6, x0, 10   #10
    addi t5, x0, 0    #loop idx
    addi a3, x0, 1    #flag of neg
    addi a4, x0, 0    #init result
    
    lb t4, 0(a0)
    beq t4, t1, Neg

    Loop:
        add a2, a0, t5
        lb t4, 0(a2)
        beq t4, t6, Final
        bge t4, t3, Cha
        bge t4, t2, Cal
    Coni:    
        addi t5, t5, 1
        beq x0, x0, Loop    


    Cal:
        sub t4, t4, t2
        mul a4, a4, a6
        add a4, a4, t4
        beq x0, x0, Coni 


    Cha:
        addi a0, x0, -1
        beq x0, x0, Exit

    Neg:
        addi a3, x0, 0
        beq x0, x0, Loop

    Final:
        beq a3, x0, Pfinal
        add a0, x0, a4
        beq x0, x0, Exit

    Pfinal:
        sub a4, x0, a4
        add a0, x0, a4
        beq x0, x0, Exit


    Exit:
        
    

    
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    
    ret

