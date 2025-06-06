set(SOURCE
    i_cbc.c i_cfb64.c i_ofb64.c i_ecb.c i_skey.c
    )
target_sources(crypto PRIVATE ${SOURCE})
