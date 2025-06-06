set(SOURCE
    store_err.c store_lib.c store_result.c store_strings.c store_meth.c
    )
if (NOT OPENSSL_NO_DEPRECATED_3_0)
    list(APPEND SOURCE store_init.c store_register.c)
endif ()
target_sources(crypto PRIVATE ${SOURCE})
