.global no_test
    ret                  # eof

.global store_test
store_test:  
    addi t0, zero, 3
    sd   t0, 56(a0)
    sd   t0, 64(a0)
    addi t1, zero, 5
    sd   t1, 72(a0)
    sd   t1, 1016(a0)
    ret                  # eof

.global load_test
load_test:  
    addi t0, zero, 3
    sd   t0, 56(a0)
    sd   t0, 72(a0)
    ld   t1, 72(a0)
    ld   t2, 56(a0)
    addi t2, t1, 128
    sd   t1, 128(a0)
    sd   t2, 256(a0)
    ret                  # eof

.global add_sub_test
add_sub_test:  
    addi t0, zero, 3
    addi t1, zero, 4
    add t2, t0, t1
    sub t3, t1, t0
    sd   t2, 64(a0)
    sd   t3, 80(a0)
    ret                  # eof

.global and_or_xor_test
and_or_xor_test:  
    addi t0, zero, 123
    addi t1, zero, 456
    and t2, t0, t1
    and t3, t1, t0
    or  t4, t0, t1
    or  t5, t1, t0
    xor t0, t2, t3
    xor t1, t4, t5
    sd   t0, 64(a0)
    sd   t1, 0(a0)
    sd   t2, 8(a0)
    sd   t3, 16(a0)
    sd   t4, 128(a0)
    sd   t5, 80(a0)
    ret                  # eof


.global andi_ori_xori_test
andi_ori_xori_test:  
    addi t0, zero, 123
    addi t1, zero, 456
    andi t2, t0, 789
    ori  t3, t0, 789
    xori t4, t0, 789
    sd   t2, 8(a0)
    sd   t3, 16(a0)
    sd   t4, 32(a0)
    ret                  # eof

.global slli_srli_test
slli_srli_test:
    addi t0, zero, 123
    addi t1, zero, 456
    slli t2, t0, 1
    srli t3, t0, 1
    sd   t2, 16(a0)
    sd   t3, 32(a0)
    ret                  # eof

.global bne_beq_test
bne_beq_test:
    addi t0, zero, 123
    addi t1, zero, 456
    addi t2, zero, 123
    bne t0, t1, b1
    sd t1, 16(a0)
    sd t2, 24(a0)
b1:
    sd t0, 32(a0)
    beq t0, t1, b2
    sd t1, 40(a0)
    sd t2, 48(a0)
    sd t0, 56(a0)
b2:
    sd t1, 64(a0)
    sd t0, 1016(a0)
    ret                  # eof
