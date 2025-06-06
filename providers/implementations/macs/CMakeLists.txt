target_sources(defprov PRIVATE gmac_prov.c hmac_prov.c kmac_prov.c)

if (NOT OPENSSL_NO_CMAC)
    target_sources(defprov PRIVATE cmac_prov.c)
endif ()

if (NOT OPENSSL_NO_BLAKE2)
    target_sources(defprov PRIVATE blake2b_mac.c blake2s_mac.c)
endif ()

if (NOT OPENSSL_NO_SIPHASH)
    target_sources(defprov PRIVATE siphash_prov.c)
endif ()

if (NOT OPENSSL_NO_POLY1305)
    target_sources(defprov PRIVATE poly1305_prov.c)
endif ()
