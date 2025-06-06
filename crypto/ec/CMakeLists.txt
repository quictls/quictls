set(SOURCE)
if (NOT OPENSSL_NO_ASM) 
    set(ecsrc_x86 ecp_nistz256.c)
    set(ecasm_x86 ${ecsrc_x86} asm/ecp_nistz256-x86.S)
    set(ecdef_x86 ECP_NISTZ256_ASM)

    set(ecsrc_x86_64 ecp_nistz256.c)
    set(ecasm_x86_64 ${ecsrc_x86_64} asm/ecp_nistz256-x86_64.s
        asm/x25519-x86_64.s)
    set(ecdef_x86_64 ECP_NISTZ256_ASM X25519_ASM)

    set(ecsrc_sparcv9 ecp_nistz256.c)
    set(ecasm_sparcv9 ${ecsrc_sparcv9} asm/ecp_nistz256-sparcv9.S)
    set(ecdef_sparcv9 ECP_NISTZ256_ASM)

    set(ecsrc_s390x ecp_s390x_nistp.c asm/ecx_s390x.c)
    set(ecasm_s390x ${ecsrc_s390x})
    set(ecdef_s390x S390X_EC_ASM)

    set(ecsrc_armv4 ecp_nistz256.c)
    set(ecasm_armv4 ${ecsrc_armv4} asm/ecp_nistz256-armv4.S)
    set(ecdef_armv4 ECP_NISTZ256_ASM)

    set(ecsrc_aarch64 ecp_nistz256.c asm/ecp_sm2p256.c)
    set(ecasm_aarch64 ${ecsrc_aarch64} asm/ecp_nistz256-armv8.S
        ecp_sm2p256-armv8.S)
    set(ecdef_aarch64 ECP_NISTZ256_ASM)
    if (NOT OPENSSL_NO_SM2)
        if (NOT OPENSSL_NO_SM2_PRECOMP)
            list(APPEND ecsrc_aarch64 ecp_sm2p256_table.c)
            list(APPEND ecasm_aarch64 ecp_sm2p256_table.c)
        endif ()
        list(APPEND ecdef_aarch64 ECP_SM2P256_ASM)
    endif ()

    set(ecsrc_ppc64 ecp_nistz256.c ecp_ppc.c)
    set(ecasm_ppc64 ${ecsrc_ppc64} ecp_nistz256-ppc64.s x25519-ppc64.s)
    set(ecdef_ppc64 ECP_NISTZ256_ASM)
    if (NOT OPENSSL_NO_EC_NISTP_64_GCC_128)
        list(APPEND ecasm_ppc64 ecp_nistp384-ppc64.s ecp_nistp521-ppc64.s)
        list(APPEND ecdef_ppc64 X25519_ASM ECP_NISTP384_ASM ECP_NISTP521_ASM)
    endif ()

    look_for_assembler(ec crypto "${ecdef_${ARCH}}")
endif ()

list(APPEND SOURCE
    ec_lib.c ecp_smpl.c ecp_mont.c ecp_nist.c ec_cvt.c ec_mult.c
    ec_curve.c ec_check.c ec_key.c ec_kmeth.c ec_asn1.c ecp_oct.c ec_oct.c
    ecdh_ossl.c ecdsa_ossl.c ecdsa_sign.c ecdsa_vrf.c ec_backend.c
    ecdh_kdf.c curve25519.c curve448/f_generic.c curve448/scalar.c
    curve448/arch_64/f_impl64.c ecx_backend.c curve448/arch_32/f_impl32.c
    curve448/curve448_tables.c curve448/eddsa.c curve448/curve448.c
    ecx_key.c ec_ameth.c ec_pmeth.c ec_err.c eck_prn.c ec_deprecated.c
    ec_print.c ecx_meth.c ${ecsrc_${ARCH}}
    )

if (NOT OPENSSL_NO_EC_NISTP_64_GCC_128)
    list(APPEND SOURCE
        ecp_nistp224.c ecp_nistp256.c ecp_nistp384.c
        ecp_nistp521.c ecp_nistputil.c)
endif ()

generate_asm_from_perl(ecp_nistz256-sparcv9.S asm/ecp_nistz256-sparcv9.pl)
generate_asm_from_perl(ecp_nistz256-armv4.S asm/ecp_nistz256-armv4.pl)
generate_asm_from_perl(ecp_nistz256-armv8.S asm/ecp_nistz256-armv8.pl)
generate_asm_from_perl(ecp_sm2p256-armv8.S asm/ecp_sm2p256-armv8.pl)
#GENERATE[ecp_nistz256-x86_64.s]=asm/ecp_nistz256-x86_64.pl
#GENERATE[ecp_nistz256-avx2.s]=asm/ecp_nistz256-avx2.pl
#GENERATE[ecp_nistz256-ppc64.s]=asm/ecp_nistz256-ppc64.pl
#GENERATE[ecp_nistp384-ppc64.s]=asm/ecp_nistp384-ppc64.pl
#GENERATE[ecp_nistp521-ppc64.s]=asm/ecp_nistp521-ppc64.pl
#GENERATE[x25519-x86_64.s]=asm/x25519-x86_64.pl
#GENERATE[x25519-ppc64.s]=asm/x25519-ppc64.pl
target_sources(crypto PRIVATE ${SOURCE})
