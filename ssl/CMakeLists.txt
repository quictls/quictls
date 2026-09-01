set(SOURCE 
    d1_lib.c d1_msg.c d1_srtp.c methods.c pqueue.c s3_enc.c s3_lib.c
    s3_msg.c ssl_cert.c ssl_lib.c ssl_sess.c bio_ssl.c ssl_asn1.c
    ssl_cert_comp.c tls_depr.c ssl_ciph.c ssl_conf.c
    ssl_err_legacy.c ssl_init.c ssl_mcnf.c ssl_rsa.c ssl_stat.c ssl_txt.c
    tls13_enc.c t1_enc.c t1_lib.c t1_trce.c
    )
if (NOT OPENSSL_NO_DEPRECATED_3_0)
    list(APPEND SOURCE ssl_rsa_legacy.c)
endif ()
if (NOT OPENSSL_NO_BORING_QUIC_API)
    list(APPEND SOURCE ssl_quic.c statem/statem_quic.c)
endif ()

if (NOT OPENSSL_NO_SHARED)
    # For shared builds we need to include some files from libcrypto
    list(APPEND SOURCE
        ../crypto/getenv.c ../crypto/packet.c ../crypto/time.c)
endif ()

target_sources(ssl PRIVATE ${SOURCE})

if (NOT OPENSSL_NO_ASM AND "${ARCH}" STREQUAL "x86_64")
    target_compile_definitions(ssl PUBLIC AES_ASM)
endif ()

add_subdirectory(record)
add_subdirectory(statem)
