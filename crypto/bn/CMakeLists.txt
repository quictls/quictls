set(SOURCE)
#  Define source files and macros per asm architecture
#  Known macros are:
#    OPENSSL_BN_ASM_PART_WORDS     For any collection with /-586/ file names
#    OPENSSL_BN_ASM_MONT           For any collection with /-mont/ file names
#    OPENSSL_BN_ASM_MONT5          For any collection with /-mont5/ file names
#    OPENSSL_IA32_SSE2             For any collection with /86/ file names
#                                  when sse2 is enabled
#    BN_DIV3W                      For any collection with /-div3w/ file names
if (NOT OPENSSL_NO_ASM)
    set(bnasm_x86 bn-586.S co-586.S x86-mont.S)
    # bn-586 is the only one implementing bn_*_part_words
    set(bndef_x86 OPENSSL_BN_ASM_PART_WORDS OPENSSL_BN_ASM_MONT)

    set(bnasm_x86_64
        x86_64-mont.s x86_64-mont5.s rsaz_exp.c rsaz-x86_64.s 
        rsaz-avx2.s rsaz_exp_x2.c rsaz-2k-avx512.s rsaz-3k-avx512.s
        rsaz-4k-avx512.s)
    if (NOT WIN32)
        list(APPEND bnasm_x64_65 asm/x86_64-gcc.c)
    else ()
        list(APPEND bnasm_x64_65 bn_asm.c)
    endif ()
    set(bndef_x86_64 OPENSSL_BN_ASM_MONT OPENSSL_BN_ASM_MONT5)
    if (NOT OPENSSL_NO_SSE2)
        list(APPEND bndef_x86 OPENSSL_IA32_SSE2)
        list(APPEND bndef_x86_64 OPENSSL_IA32_SSE2)
    endif ()

    set(bnasm_sparcv9 asm/sparcv8plus.S sparcv9-mont.S sparcv9a-mont.S
        vis3-mont.S sparct4-mont.S bn_sparc.c)
    set(bndef_sparcv9 OPENSSL_BN_ASM_MONT)
    set(bnasm_sparcv8 asm/sparcv8.S)

    set(bnasm_alpha bn_asm.c alpha-mont.S)
    set(bndef_alpha OPENSSL_BN_ASM_MONT)

    set(bnasm_mips32 bn-mips.S mips-mont.S)
    set(bndef_mips32 OPENSSL_BN_ASM_MONT)
    set(bnasm_mips64 ${bnasm_maps32})
    set(bndef_mips64 ${bndef_maps32})

    if (S390X_HASH_HIGHGPRS)
        set(bnasm_s390x bn_asm.c s390x-mont.S)
    else ()
        set(bnasm_s390x asm/s390x.S s390x-mont.S bn_s390x.c)
    endif ()
    set(bndef_s390x OPENSSL_BN_ASM_MONT)

    set(bnasm_armv4 bn_asm.c armv4-mont.S)
    set(bndef_armv4 OPENSSL_BN_ASM_MONT)

    set(bnasm_aarch64 bn_asm.c armv8-mont.S)
    set(bndef_aarch64 OPENSSL_BN_ASM_MONT)

    set(bnasm_ppc32 bn_ppc.c bn-ppc.s ppc-mont.s)
    set(bndef_ppc32 OPENSSL_BN_ASM_MONT)
    set(bnasm_ppc64 ${bnasm_ppc32} ppc64-mont-fixed.s)
    set(bndef_ppc64 ${bnasm_ppc32})

    look_for_assembler(aes crypto "${bndef_${ARCH}}")
endif ()

if (NOT FOUND)
    list(APPEND SOURCE bn_asm.c)
endif ()
list(APPEND SOURCE
    bn_add.c bn_div.c bn_exp.c bn_lib.c bn_ctx.c bn_mul.c bn_mod.c bn_conv.c
    bn_rand.c bn_shift.c bn_word.c bn_blind.c bn_kron.c bn_sqrt.c bn_gcd.c
    bn_prime.c bn_sqr.c bn_recp.c bn_mont.c bn_mpi.c bn_exp2.c bn_nist.c
    bn_intern.c bn_dh.c bn_rsa_fips186_4.c bn_const.c bn_print.c bn_err.c
    )
if (NOT OPENSSL_NO_DEPRECATED_0_9_8)
    list(APPEND SOURCE bn_depr.c)
endif ()
if (NOT OPENSSL_NO_DEPRECATED_3_0)
    list(APPEND SOURCE bn_x931p.c)
endif ()

generate_asm_from_perl(alpha-mont.S asm/alpha-mont.pl)
generate_asm_from_perl(armv4-mont.S asm/armv4-mont.pl)
generate_asm_from_perl(armv8-mont.S asm/armv8-mont.pl)
generate_asm_from_perl(bn-586.S asm/bn-586.pl)
generate_asm_from_perl(bn-mips.S asm/mips.pl)
generate_asm_from_perl(co-586.S asm/co-586.pl)
generate_asm_from_perl(mips-mont.S asm/mips-mont.pl)
generate_asm_from_perl(s390x-mont.S asm/s390x-mont.pl)
generate_asm_from_perl(sparct4-mont.S asm/sparct4-mont.pl)
generate_asm_from_perl(sparcv9a-mont.S asm/sparcv9a-mont.pl)
generate_asm_from_perl(sparcv9-mont.S asm/sparcv9-mont.pl)
generate_asm_from_perl(vis3-mont.S asm/vis3-mont.pl)
generate_asm_from_perl(x86-mont.S asm/x86-mont.pl)
#GENERATE[bn-ppc.s]=asm/ppc.pl
#GENERATE[ppc64-mont-fixed.s]=asm/ppc64-mont-fixed.pl
#GENERATE[ppc64-mont.s]=asm/ppc64-mont.pl
#GENERATE[ppc-mont.s]=asm/ppc-mont.pl
#GENERATE[rsaz-2k-avx512.s]=asm/rsaz-2k-avx512.pl
#GENERATE[rsaz-3k-avx512.s]=asm/rsaz-3k-avx512.pl
#GENERATE[rsaz-4k-avx512.s]=asm/rsaz-4k-avx512.pl
#GENERATE[rsaz-avx2.s]=asm/rsaz-avx2.pl
#GENERATE[rsaz-x86_64.s]=asm/rsaz-x86_64.pl
#GENERATE[x86_64-mont5.s]=asm/x86_64-mont5.pl
#GENERATE[x86_64-mont.s]=asm/x86_64-mont.pl
target_sources(crypto PRIVATE ${SOURCE})
