set(SOURCE
    encoder_meth.c encoder_lib.c encoder_pkey.c decoder_meth.c decoder_lib.c
    decoder_pkey.c encoder_err.c decoder_err.c
    )
target_sources(crypto PRIVATE ${SOURCE})
