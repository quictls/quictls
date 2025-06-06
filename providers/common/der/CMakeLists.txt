target_sources(common PRIVATE 
    der_rsa_key.c der_rsa_gen.c der_digests_gen.c
    der_wrap_gen.c)

if (NOT OPENSSL_NO_EC)
    target_sources(common PRIVATE 
        der_ec_gen.c der_ec_key.c der_ec_sig.c der_ecx_gen.c
        der_ecx_key.c)
endif ()

if (NOT OPENSSL_NO_DSA)
    target_sources(common PRIVATE der_dsa_gen.c der_dsa_key.c der_dsa_sig.c)
endif ()

if (NOT OPENSSL_NO_SM2)
    target_sources(common PRIVATE der_sm2_gen.c der_sm2_key.c der_sm2_sig.c)
endif ()
