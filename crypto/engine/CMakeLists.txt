set(SOURCE
    eng_all.c eng_cnf.c eng_ctrl.c eng_dyn.c eng_err.c eng_fat.c eng_init.c
    eng_lib.c eng_list.c eng_openssl.c eng_pkey.c eng_table.c tb_asnmth.c
    tb_cipher.c tb_dh.c tb_digest.c tb_dsa.c tb_eckey.c tb_pkmeth.c
    tb_rand.c tb_rsa.c
    )
target_sources(crypto PRIVATE ${SOURCE})
