.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
        addi    sp,sp,-144
        sd      s8,72(sp)
        li      s8,32768
        addi    a5,s8,256
        addi    a4,a0,256
        add     a5,a2,a5
        sd      s7,80(sp)
        sd      s9,64(sp)
        sd      s10,56(sp)
        sd      s11,48(sp)
        sd      s0,136(sp)
        sd      s1,128(sp)
        sd      s2,120(sp)
        sd      s3,112(sp)
        sd      s4,104(sp)
        sd      s5,96(sp)
        sd      s6,88(sp)
        li      s7,-32768
        mv      s9,a2
        mv      s10,a0
        mv      s11,a1
        sd      a4,8(sp)
        sd      a5,16(sp)
.L4:
        addi    a5,s10,2
        sd      a5,24(sp)
        addi    a5,s10,4
        sd      a5,32(sp)
        addi    a5,s10,6
        addi    t6,s11,256
        addi    t5,s11,512
        addi    t4,s11,768
        add     s6,s9,s8
        mv      t3,s11
        sd      a5,40(sp)
.L3:
        li      a5,-32768
        addi    a4,a5,2
        ld      a7,24(sp)
        ld      a6,32(sp)
        ld      a3,40(sp)
        add     a2,s6,a4
        addi    a4,a5,4
        addi    a5,a5,6
        add     t2,s6,a4
        add     t1,s6,s7
        add     t0,s6,a5
        mv      a4,s10
.L2:
        lhu     s4,0(a4)
        lhu     a5,0(t3)
        lhu     s0,0(a7)
        lhu     s3,0(t6)
        lhu     a0,0(a6)
        lhu     s2,0(t5)
        lhu     a1,0(a3)
        lhu     s1,0(t4)
        mulw    a5,s4,a5
        lhu     s4,0(t1)
        addi    t1,t1,256
        addi    a4,a4,256
        addi    a7,a7,256
        addi    a6,a6,256
        addi    a3,a3,256
        addi    a2,a2,256
        addi    t2,t2,256
        addi    t0,t0,256
        mulw    s0,s0,s3
        addw    a5,a5,s4
        mulw    a0,a0,s2
        add     s0,a5,s0
        mulw    a1,a1,s1
        add     a0,s0,a0
        add     a1,a0,a1
        andi    a1,a1,1023
        sh      a1,-256(t1)
        lhu     s4,-256(a4)
        lhu     a5,2(t3)
        lhu     s3,2(t6)
        lhu     s0,-256(a7)
        lhu     s2,2(t5)
        lhu     a0,-256(a6)
        lhu     s1,2(t4)
        lhu     a1,-256(a3)
        mulw    a5,s4,a5
        lhu     s4,-256(a2)
        mulw    s0,s0,s3
        addw    a5,a5,s4
        mulw    a0,a0,s2
        add     s0,a5,s0
        mulw    a1,a1,s1
        add     a0,s0,a0
        add     a1,a0,a1
        andi    a1,a1,1023
        sh      a1,-256(a2)
        lhu     s4,-256(a4)
        lhu     a5,4(t3)
        lhu     s0,-256(a7)
        lhu     s3,4(t6)
        lhu     s2,4(t5)
        lhu     a0,-256(a6)
        lhu     s1,4(t4)
        lhu     a1,-256(a3)
        mulw    a5,s4,a5
        lhu     s4,-256(t2)
        mulw    s0,s0,s3
        addw    a5,a5,s4
        mulw    a0,a0,s2
        add     s0,a5,s0
        mulw    a1,a1,s1
        add     a0,s0,a0
        add     a1,a0,a1
        andi    a1,a1,1023
        sh      a1,-256(t2)
        lhu     a5,-256(a4)
        lhu     s5,6(t3)
        lhu     s3,-256(t0)
        lhu     s0,-256(a7)
        lhu     s4,6(t6)
        lhu     a0,-256(a6)
        lhu     s2,6(t5)
        lhu     a1,-256(a3)
        lhu     s1,6(t4)
        mulw    a5,a5,s5
        mulw    s0,s0,s4
        addw    a5,a5,s3
        mulw    a0,a0,s2
        add     a5,a5,s0
        mulw    a1,a1,s1
        add     a5,a5,a0
        add     a5,a5,a1
        andi    a5,a5,1023
        sh      a5,-256(t0)
        bne     s6,t1,.L2
        ld      a5,16(sp)
        addi    s6,s6,8
        addi    t3,t3,8
        addi    t6,t6,8
        addi    t5,t5,8
        addi    t4,t4,8
        bne     a5,s6,.L3
        ld      a5,8(sp)
        addi    s10,s10,8
        addi    s11,s11,1024
        bne     a5,s10,.L4
        ld      s0,136(sp)
        ld      s1,128(sp)
        ld      s2,120(sp)
        ld      s3,112(sp)
        ld      s4,104(sp)
        ld      s5,96(sp)
        ld      s6,88(sp)
        ld      s7,80(sp)
        ld      s8,72(sp)
        ld      s9,64(sp)
        ld      s10,56(sp)
        ld      s11,48(sp)
        addi    sp,sp,144
        jr      ra
    ret
