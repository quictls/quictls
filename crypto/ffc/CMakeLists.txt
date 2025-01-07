set(SOURCE
    ffc_params.c ffc_params_generate.c ffc_key_generate.c
    ffc_params_validate.c ffc_key_validate.c ffc_backend.c ffc_dh.c
    )
target_sources(crypto PRIVATE ${SOURCE})
