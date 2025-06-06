set(SOURCE
    hpke.c hpke_util.c
    )
target_sources(crypto PRIVATE ${SOURCE})
