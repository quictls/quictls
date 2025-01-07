set(SOURCE
    rc2_ecb.c rc2_skey.c rc2_cbc.c rc2cfb64.c rc2ofb64.c
    )
target_sources(crypto PRIVATE ${SOURCE})
