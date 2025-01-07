target_sources(defprov PRIVATE rsa_enc.c)
if (NOT OPENSSL_NO_SM2)
    target_sources(defprov PRIVATE sm2_enc.c)
endif ()
