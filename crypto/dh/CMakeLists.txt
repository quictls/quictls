set(SOURCE
    dh_ameth.c dh_asn1.c dh_backend.c dh_check.c dh_err.c dh_gen.c
    dh_group_params.c dh_kdf.c dh_key.c dh_lib.c dh_meth.c dh_pmeth.c
    dh_prn.c dh_rfc5114.c
    )

if (NOT OPENSSL_NO_DEPRECATED_0_9_8)
    list(APPEND SOURCE dh_depr.c)
endif ()
target_sources(crypto PRIVATE ${SOURCE})
