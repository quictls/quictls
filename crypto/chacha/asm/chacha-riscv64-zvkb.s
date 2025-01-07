.text
.p2align 3
.globl ChaCha20_ctr32_zvkb
.type ChaCha20_ctr32_zvkb,@function
ChaCha20_ctr32_zvkb:
    srli a2, a2, 6
    beqz a2, .Lend

    addi sp, sp, -96
    sd s0, 0(sp)
    sd s1, 8(sp)
    sd s2, 16(sp)
    sd s3, 24(sp)
    sd s4, 32(sp)
    sd s5, 40(sp)
    sd s6, 48(sp)
    sd s7, 56(sp)
    sd s8, 64(sp)
    sd s9, 72(sp)
    sd s10, 80(sp)
    sd s11, 88(sp)

    li t3, 64

    #### chacha block data
    # "expa" little endian
    li a5, 0x61707865
    # "nd 3" little endian
    li a6, 0x3320646e
    # "2-by" little endian
    li a7, 0x79622d32
    # "te k" little endian
    li t1, 0x6b206574

    lw s0, 0(a3)
    lw s1, 4(a3)
    lw s2, 8(a3)
    lw s3, 12(a3)
    lw s4, 16(a3)
    lw s5, 20(a3)
    lw s6, 24(a3)
    lw s7, 28(a3)

    lw s8, 0(a4)
    lw s9, 4(a4)
    lw s10, 8(a4)
    lw s11, 12(a4)

.Lblock_loop:
    .word 218526679

    # init chacha const states
    .word 1577566295
    .word 1577599191
    .word 1577632087
    .word 1577271767

    # init chacha key states
    .word 1577337431
    .word 1577370327
    .word 1577665367
    .word 1577698263
    .word 1577731159
    .word 1577764055
    .word 1577796951
    .word 1577829847

    # init chacha key states
    .word 1376298583
    .word 46941783
    .word 1577895639

    # init chacha nonce states
    .word 1577928535
    .word 1577961431

    # load the top-half of input data
    .word 3955615751

    li t4, 10
.Lround_loop:
    addi t4, t4, -1
        # a += b; d ^= a; d <<<= 16;
    .word 33685591
    .word 34767063
    .word 35848535
    .word 36930007
    .word 784336471
    .word 785417943
    .word 786499415
    .word 787580887
    .word 1388852823
    .word 1389901527
    .word 1390950231
    .word 1391998935
    # c += d; b ^= c; b <<<= 12;
    .word 42337367
    .word 43418839
    .word 44500311
    .word 45581783
    .word 776208983
    .word 777290455
    .word 778371927
    .word 779453399
    .word 1380594263
    .word 1381642967
    .word 1382691671
    .word 1383740375
    # a += b; d ^= a; d <<<= 8;
    .word 33685591
    .word 34767063
    .word 35848535
    .word 36930007
    .word 784336471
    .word 785417943
    .word 786499415
    .word 787580887
    .word 1389114967
    .word 1390163671
    .word 1391212375
    .word 1392261079
    # c += d; b ^= c; b <<<= 7;
    .word 42337367
    .word 43418839
    .word 44500311
    .word 45581783
    .word 776208983
    .word 777290455
    .word 778371927
    .word 779453399
    .word 1380758103
    .word 1381806807
    .word 1382855511
    .word 1383904215

        # a += b; d ^= a; d <<<= 16;
    .word 33718359
    .word 34799831
    .word 35881303
    .word 36831703
    .word 787482583
    .word 784369239
    .word 785450711
    .word 786532183
    .word 1391998935
    .word 1388852823
    .word 1389901527
    .word 1390950231
    # c += d; b ^= c; b <<<= 12;
    .word 44533079
    .word 45483479
    .word 42370135
    .word 43451607
    .word 777323223
    .word 778404695
    .word 779355095
    .word 776241751
    .word 1381642967
    .word 1382691671
    .word 1383740375
    .word 1380594263
    # a += b; d ^= a; d <<<= 8;
    .word 33718359
    .word 34799831
    .word 35881303
    .word 36831703
    .word 787482583
    .word 784369239
    .word 785450711
    .word 786532183
    .word 1392261079
    .word 1389114967
    .word 1390163671
    .word 1391212375
    # c += d; b ^= c; b <<<= 7;
    .word 44533079
    .word 45483479
    .word 42370135
    .word 43451607
    .word 777323223
    .word 778404695
    .word 779355095
    .word 776241751
    .word 1381806807
    .word 1382855511
    .word 1383904215
    .word 1380758103

    bnez t4, .Lround_loop

    # load the bottom-half of input data
    addi t0, a1, 32
    .word 3955420167

    # add chacha top-half initial block states
    .word 34062423
    .word 35143895
    .word 36225367
    .word 36913623
    .word 38027863
    .word 39109335
    .word 40452951
    .word 41534423
    # xor with the top-half input
    .word 788531287
    .word 789612759
    .word 790694231
    .word 791775703
    .word 792857175
    .word 793938647
    .word 795020119
    .word 796101591

    # save the top-half of output
    .word 3955583015

    # add chacha bottom-half initial block states
    .word 42615895
    .word 43697367
    .word 44778839
    .word 45860311
    .word 1376297047
    .word 46941783
    .word 48023255
    .word 49104727
    .word 50186199
    .word 46138967
    # xor with the bottom-half input
    .word 797183063
    .word 798264535
    .word 799346007
    .word 800427479
    .word 802590423
    .word 801508951
    .word 803671895
    .word 804753367

    # save the bottom-half of output
    addi t0, a0, 32
    .word 3955420199

    # update counter
    add s8, s8, t2
    sub a2, a2, t2
    # increase offset for `4 * 16 * VL = 64 * VL`
    slli t0, t2, 6
    add a1, a1, t0
    add a0, a0, t0
    bnez a2, .Lblock_loop

    ld s0, 0(sp)
    ld s1, 8(sp)
    ld s2, 16(sp)
    ld s3, 24(sp)
    ld s4, 32(sp)
    ld s5, 40(sp)
    ld s6, 48(sp)
    ld s7, 56(sp)
    ld s8, 64(sp)
    ld s9, 72(sp)
    ld s10, 80(sp)
    ld s11, 88(sp)
    addi sp, sp, 96

.Lend:
    ret
.size ChaCha20_ctr32_zvkb,.-ChaCha20_ctr32_zvkb
