if (NOT OPENSSL_NO_ASM)
    set(ghashdef_x86 GHASH_ASM)
    set(ghashdef_x86_sse2 OPENSSL_IA32_SSE2)
    set(ghashdef_x86_64 GHASH_ASM)
    set(ghashdef_x86_64_sse2 OPENSSL_IA32_SSE2)
    set(ghashdef_sparcv9 GHASH_ASM)
    set(ghashdef_alpha GHASH_ASM)
    set(ghashdef_s390x GHASH_ASM)
    set(ghashdef_armv4 GHASH_ASM)
    set(ghashdef_ppc64 $GHASHDEF_ppc32)
    set(ghashdef_riscv64 GHASH_ASM)
    if (DEFINED ghashdef_${ARCH})
        set(ghashdef ${ghashdef_${ARCH}})
        if (DEFINED ghashdef_${ARCH}_sse2)
            list(APPEND ghashdef ${ghashdef_${ARCH}_sse2})
        endif ()
    endif ()
endif ()

target_sources(common PRIVATE
    ciphercommon_block.c ciphercommon_gcm.c
    ciphercommon.c ciphercommon_hw.c
    ciphercommon_gcm_hw.c ciphercommon_ccm.c
    ciphercommon_ccm_hw.c)

target_sources(defprov PRIVATE 
    cipher_null.c cipher_aes.c cipher_aes_hw.c cipher_aes_xts.c
    cipher_aes_xts_hw.c cipher_aes_gcm.c cipher_aes_gcm_hw.c
    cipher_aes_ccm.c cipher_aes_ccm_hw.c cipher_aes_wrp.c
    cipher_aes_cbc_hmac_sha.c cipher_aes_cbc_hmac_sha256_hw.c
    cipher_aes_cbc_hmac_sha1_hw.c cipher_cts.c cipher_aes_xts_fips.c
    )

if (NOT OPENSSL_NO_DES)
    target_sources(defprov PRIVATE cipher_tdes.c cipher_tdes_common.c cipher_tdes_hw.c)
endif ()

if (NOT OPENSSL_NO_SIV)
    if (ghash_def)
        target_compile_definitions(defprov ${ghash_def})
    endif ()
    target_sources(defprov PRIVATE 
        cipher_aes_gcm_siv.c cipher_aes_gcm_siv_hw.c
        cipher_aes_gcm_siv_polyval.c cipher_aes_siv.c cipher_aes_siv_hw.c
        )
endif ()

if (NOT OPENSSL_NO_DES)
    target_sources(defprov PRIVATE 
        cipher_tdes_default.c cipher_tdes_default_hw.c cipher_tdes_wrap.c
        cipher_tdes_wrap_hw.c cipher_desx.c cipher_desx_hw.c cipher_des.c
        cipher_des_hw.c cipher_tdes_common.c
        )
endif ()

if (NOT OPENSSL_NO_ARIA)
    target_sources(defprov PRIVATE 
        cipher_aria.c cipher_aria_hw.c cipher_aria_gcm.c
        cipher_aria_gcm_hw.c cipher_aria_ccm.c cipher_aria_ccm_hw.c
        )
endif ()

if (NOT OPENSSL_NO_CAMELLIA)
    target_sources(defprov PRIVATE cipher_camellia.c cipher_camellia_hw.c)
endif ()

if (NOT OPENSSL_NO_BF)
    target_sources(defprov PRIVATE cipher_blowfish.c cipher_blowfish_hw.c)
endif ()

if (NOT OPENSSL_NO_IDEA)
    target_sources(defprov PRIVATE cipher_idea.c cipher_idea_hw.c)
endif ()

if (NOT OPENSSL_NO_CAST)
    target_sources(defprov PRIVATE cipher_cast5.c cipher_cast5_hw.c)
endif ()

if (NOT OPENSSL_NO_SEED)
    target_sources(defprov PRIVATE cipher_seed.c cipher_seed_hw.c)
endif ()

if (NOT OPENSSL_NO_SM4)
    target_sources(defprov PRIVATE 
        cipher_sm4.c cipher_sm4_hw.c cipher_sm4_gcm.c cipher_sm4_gcm_hw.c
        cipher_sm4_ccm.c cipher_sm4_ccm_hw.c cipher_sm4_xts.c
        cipher_sm4_xts_hw.c
        )
endif ()

if (NOT OPENSSL_NO_OCB)
    target_sources(defprov PRIVATE cipher_aes_ocb.c cipher_aes_ocb_hw.c)
endif ()

if (NOT OPENSSL_NO_RC4)
    target_sources(defprov PRIVATE cipher_rc4.c cipher_rc4_hw.c)
    if (NOT OPENSSL_NO_MD5)
        target_sources(defprov PRIVATE cipher_rc4_hmac_md5.c cipher_rc4_hmac_md5_hw.c)
    endif ()
endif ()

if (NOT OPENSSL_NO_RC5)
    target_sources(defprov PRIVATE cipher_rc5.c cipher_rc5_hw.c)
endif ()

if (NOT OPENSSL_NO_RC2)
    target_sources(defprov PRIVATE cipher_rc2.c cipher_rc2_hw.c)
endif ()

if (NOT OPENSSL_NO_CHACHA)
    target_sources(defprov PRIVATE cipher_chacha20.c cipher_chacha20_hw.c)
    if (NOT OPENSSL_NO_POLY1305)
        target_sources(defprov PRIVATE
            cipher_chacha20_poly1305.c cipher_chacha20_poly1305_hw.c
            )
    endif ()
endif ()
