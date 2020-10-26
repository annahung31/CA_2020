.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
    
    # insert code here
    addi t0, x0, 4  #bsize
    add s10, zero, 128  #n
    add s11, zero, a1 # B 
    add t1, zero, zero # kk = 0 
    L0:
        add t2, zero, zero # jj = 0
        add a7, t2, t0     # jj + bsize
    
    L1:
        add t3, zero, zero # i = 0
    L2:
        add t4, zero, t2 # j = jj
    L3:
        lhu a3, 0(a2)      # sum = C[i][j]
        add t5, zero, t1   # k = kk
        add t6, t5, t0     # kk + bsize
    L4:
        add a4, a0, t5     # idx of A
        lhu a5, 0(a4)      # A[i][k]
        lhu a6, 0(s11)     # B[k][j]
        mul a5, a5, a6     # A[i][k] x B[k][j]
        add a3, a3, a5     # sum += A[i][k] x B[k][j]
        andi a3, a3, 1023  # mod 1024
        addi a4, a4, 2     # A[i][k+1]
        addi s11, s11, 256 # B[k+1][j]
        addi t5, t5, 1     # k++ 
        blt t5, t6, L4     # k< kk+bsize , continue
        sh a3, 0(a2)       # store back to C[i][j]
        addi a2, a2, 2     # C[i][j+1]
        add t4, t4, 1      # j++
        blt t4, a7, L3     # j < jj + bsize , continue
        # j loop end

        add t3, t3, 1      # i++
        add a2, a2, 256    # c[i+1][j]
        add a5, a5, 256    # A[i+1][k]
        blt t3, s10, L2    # i <  size , continue
        # i loop end

        add t2, t2, 1      # jj++
        blt t2, s10, L1    # jj < size, continue
        #jj loop end

        add t1, t1, 1      # kk++
        blt t1, s10, L0    # kk < size, continue
        #kk loop end



    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    # Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
    
    ret
