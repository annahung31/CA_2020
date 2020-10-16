.global fibonacci
.type fibonacci, %function

.align 2
# unsigned long long int fibonacci(int n);
fibonacci:  

    addi t3, x0, 1
    blt a0, t3, Base  #base case when n < 1, return 0


    addi t0, x0, 1 
    mul t0, t0, a0  #to store the input max 
    addi t1, x0, 1  # i 
    mul t1, t1, x0  # i start from 0
    mul a0, a0, x0  #a0 return to 0
    

    
    addi t2, x0, 1  # i 
    mul t2, t2, x0  # temp to save a_i-1




    bne t0, x0, Loop
    Loop:
        add a0, a0, t1
        beq t1, t0, Exit
        add t1, t1, 1
        beq x0, x0, Loop

    Base:
        mul a0, a0, x0
        beq x0, x0, Exit

    Exit:
        
     
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    
    ret
    
