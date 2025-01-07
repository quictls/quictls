set(SOURCE
    ess_asn1.c ess_err.c ess_lib.c
    )
target_sources(crypto PRIVATE ${SOURCE})
