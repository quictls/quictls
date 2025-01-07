set(SOURCE
    rand_lib.c randfile.c rand_err.c prov_seed.c rand_pool.c rand_uniform.c
    )
if (NOT OPENSSL_NO_DEPRECATED_3_0)
    list(APPEND SOURCE rand_meth.c)
endif ()
target_sources(crypto PRIVATE ${SOURCE})
