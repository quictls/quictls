target_sources(defprov PRIVATE rsa_kem.c)

if (NOT OPENSSL_NO_EC)
    target_sources(defprov PRIVATE kem_util.c ec_kem.c ecx_kem.c)
endif ()
