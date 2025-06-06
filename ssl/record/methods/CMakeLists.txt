set(SOURCE
    tls_common.c ssl3_meth.c tls1_meth.c tls13_meth.c tlsany_meth.c
    dtls_meth.c tls_multib.c tls_pad.c
    )
if (NOT OPENSSL_NO_KTLS)
    list(APPEND SOURCE ktls_meth.c)
endif ()
if (NOT OPENSSL_NO_SHARED)
    if (NOT OPENSSL_NO_DEPRECATED_3_0)
        list(APPEND SOURCE ssl3_cbc.c)
    endif ()
    list(APPEND SOURCE tls_pad.c)
endif ()

target_sources(ssl PRIVATE ${SOURCE})

#SOURCE[../../../providers/libdefault.a ../../../providers/libfips.a]=ssl3_cbc.c

