set(SOURCE
    seed.c seed_ecb.c seed_cbc.c seed_cfb.c seed_ofb.c
    )
target_sources(crypto PRIVATE ${SOURCE})
