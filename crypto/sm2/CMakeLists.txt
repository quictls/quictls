set(SOURCE
    sm2_sign.c sm2_crypt.c sm2_err.c sm2_key.c
    )
target_sources(crypto PRIVATE ${SOURCE})
