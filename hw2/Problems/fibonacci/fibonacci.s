.global fibonacci
.type fibonacci, %function

.align 2
# unsigned long long int fibonacci(int n);
fibonacci:  

    addi t4, x0, 2
    blt a0, t4, Exit  #when n < 2, return a0
 
    add t0, x0, a0 #to store the input max 
    addi t1, x0, 2  # i start from 2
    mul a0, a0, x0  #a0 return to 0
    
    addi t2, x0, 1  # temp to save a_i-1, init=1
    addi t3, x0, 0  # temp to save a_i-2, init=0 

    bne t0, x0, Loop

    Loop:
                               
        add a0, t2, t3
        add t3, x0, t2
        add t2, x0, a0
        beq t1, t0, Exit
        add t1, t1, 1
        beq x0, x0, Loop


    Exit:
        
     
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    
    ret
    
