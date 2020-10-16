.global fibonacci
.type fibonacci, %function

.align 2
# unsigned long long int fibonacci(int n);
fibonacci:  
    addi t0, x0, 1
    addi t1, x0, 1
    mul t0, t0, a0
    Loop:
        
     
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    
    ret
    
