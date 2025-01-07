set(SOURCE
    digest.c evp_enc.c evp_lib.c evp_fetch.c evp_utils.c mac_lib.c
    mac_meth.c keymgmt_meth.c keymgmt_lib.c kdf_lib.c kdf_meth.c
    m_sigver.c pmeth_lib.c signature.c p_lib.c pmeth_gn.c exchange.c
    evp_rand.c asymcipher.c kem.c dh_support.c ec_support.c pmeth_check.c
    encode.c evp_key.c evp_cnf.c e_des.c e_bf.c e_idea.c e_des3.c e_rc4.c
    e_aes.c names.c e_aria.c e_sm4.c e_xcbc_d.c e_rc2.c e_cast.c e_rc5.c
    m_null.c p_seal.c p_sign.c p_verify.c p_legacy.c bio_md.c bio_b64.c
    bio_enc.c evp_err.c e_null.c c_allc.c c_alld.c bio_ok.c evp_pkey.c
    evp_pbe.c p5_crpt.c p5_crpt2.c pbe_scrypt.c e_aes_cbc_hmac_sha1.c
    e_aes_cbc_hmac_sha256.c e_rc4_hmac_md5.c e_chacha20_poly1305.c
    legacy_sha.c ctrl_params_translate.c cmeth_lib.c dh_ctrl.c dsa_ctrl.c
    ec_ctrl.c
    )
if (NOT OPENSSL_NO_DEPRECATED_3_0)
    list(APPEND SOURCE p_enc.c p_dec.c)
endif ()
if (NOT OPENSSL_NO_DEPRECATED_0_9_8)
    list(APPEND SOURCE e_old.c)
endif ()
if (NOT OPENSSL_NO_RSA)
    list(APPEND SOURCE p_open.c)
endif ()
if (NOT OPENSSL_NO_MD2)
    list(APPEND SOURCE legacy_md2.c)
endif ()
if (NOT OPENSSL_NO_MD4)
    list(APPEND SOURCE legacy_md4.c)
endif ()
if (NOT OPENSSL_NO_MD5)
    list(APPEND SOURCE legacy_md5.c legacy_md5_sha1.c)
endif ()
if (NOT OPENSSL_NO_MDC2)
    list(APPEND SOURCE legacy_mdc2.c)
endif ()
if (NOT OPENSSL_NO_BLAKE2)
    list(APPEND SOURCE legacy_blake2.c)
endif ()
if (NOT OPENSSL_NO_WHIRLPOOL)
    list(APPEND SOURCE legacy_wp.c)
endif ()
if (NOT OPENSSL_NO_RMD160)
    list(APPEND SOURCE legacy_ripemd.c)
endif ()
if (NOT OPENSSL_NO_SEED)
    list(APPEND SOURCE e_seed.c)
endif ()
if (NOT OPENSSL_NO_CAMELLIA)
    list(APPEND SOURCE e_camellia.c)
endif ()

target_sources(crypto PRIVATE ${SOURCE})
target_include_directories(crypto PRIVATE ../modes)
