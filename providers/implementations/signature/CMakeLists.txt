target_sources(defprov PRIVATE rsa_sig.c mac_legacy_sig.c)

if (NOT OPENSSL_NO_DSA)
    target_sources(defprov PRIVATE dsa_sig.c)
endif ()

if (NOT OPENSSL_NO_EC)
    target_sources(defprov PRIVATE ecdsa_sig.c eddsa_sig.c)
endif ()

if (NOT OPENSSL_NO_SM2)
    target_sources(defprov PRIVATE sm2_sig.c)
endif ()

#DEPEND[rsa_sig.o]=../../../include/providers/der_rsa.h
#DEPEND[dsa_sig.o]=../../../include/providers/der_dsa.h
#DEPEND[ecdsa_sig.o]=../../../include/providers/der_ec.h
#DEPEND[eddsa_sig.o]=../../../include/providers/der_ecx.h
#DEPEND[sm2_sig.o]=../../../include/providers/der_sm2.h
