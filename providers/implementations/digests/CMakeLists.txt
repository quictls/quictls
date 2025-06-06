
target_sources(defprov PRIVATE digestcommon.c sha2_prov.c sha3_prov.c null_prov.c)

if (NOT OPENSSL_NO_BLAKE2)
    target_sources(defprov PRIVATE blake2_prov.c blake2b_prov.c blake2s_prov.c)
endif ()

if (NOT OPENSSL_NO_SM3)
    target_sources(defprov PRIVATE sm3_prov.c)
endif ()

if (NOT OPENSSL_NO_MD5)
    target_sources(defprov PRIVATE md5_prov.c md5_sha1_prov.c)
endif ()

if (NOT OPENSSL_NO_MD2)
    target_sources(defprov PRIVATE md2_prov.c)
endif ()

if (NOT OPENSSL_NO_MD4)
    target_sources(defprov PRIVATE md4_prov.c)
endif ()

if (NOT OPENSSL_NO_MDC2)
    target_sources(defprov PRIVATE mdc2_prov.c)
endif ()

if (NOT OPENSSL_NO_WHIRLPOOL)
    target_sources(defprov PRIVATE wp_prov.c)
endif ()

if (NOT OPENSSL_NO_RMD160)
    target_sources(defprov PRIVATE ripemd_prov.c)
endif ()
