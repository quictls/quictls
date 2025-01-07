set(SUBDIRS
    aes asn1 bio bn buffer conf dso encode_decode evp ffc hmac
    hpke kdf lhash modes objects pem pkcs12 pkcs7 property rand sha stack
    store thread txt_db ui x509)

set(ASM_DEFS)
include(Utilities.cmake)

# Mainline cryptographic algorithms.
maybe_add_directory(OPENSSL_NO_ARIA     aria)
maybe_add_directory(OPENSSL_NO_CAMELLIA camellia)
maybe_add_directory(OPENSSL_NO_CHACHA   chacha)
maybe_add_directory(OPENSSL_NO_CMAC     cmac)
maybe_add_directory(OPENSSL_NO_DH       dh)
maybe_add_directory(OPENSSL_NO_DSA      dsa)
maybe_add_directory(OPENSSL_NO_EC       ec)
maybe_add_directory(OPENSSL_NO_POLY1305 poly1305)
maybe_add_directory(OPENSSL_NO_RSA      rsa)
maybe_add_directory(OPENSSL_NO_SIPHASH  siphash)
maybe_add_directory(OPENSSL_NO_SM2      sm2)
maybe_add_directory(OPENSSL_NO_SM3      sm3)
maybe_add_directory(OPENSSL_NO_SM4      sm4)

# Algorithms that could end up in the legacy module.
maybe_add_directory(OPENSSL_NO_BF       bf)
maybe_add_directory(OPENSSL_NO_CAST     cast)
maybe_add_directory(OPENSSL_NO_DES      des)
maybe_add_directory(OPENSSL_NO_IDEA     idea)
maybe_add_directory(OPENSSL_NO_MD2      md2)
maybe_add_directory(OPENSSL_NO_MD4      md4)
maybe_add_directory(OPENSSL_NO_MD5      md5)# Only if DOS
maybe_add_directory(OPENSSL_NO_MDC2     mdc2)
maybe_add_directory(OPENSSL_NO_RC2      rc2)
maybe_add_directory(OPENSSL_NO_RC4      rc4)
maybe_add_directory(OPENSSL_NO_RC5      rc5)
maybe_add_directory(OPENSSL_NO_RMD160   ripemd)
maybe_add_directory(OPENSSL_NO_SEED     seed)
maybe_add_directory(OPENSSL_NO_WHIRPOOL whrlpool)

# Other library features
maybe_add_directory(OPENSSL_NO_ASYNC    async)
maybe_add_directory(OPENSSL_NO_CMP      cmp)
maybe_add_directory(OPENSSL_NO_CMS      cms)
maybe_add_directory(OPENSSL_NO_COMP     comp)
maybe_add_directory(OPENSSL_NO_CRMF     crmf)
maybe_add_directory(OPENSSL_NO_CT       ct)
maybe_add_directory(OPENSSL_NO_ENGINE   engine)
maybe_add_directory(OPENSSL_NO_ERR      err)
maybe_add_directory(OPENSSL_NO_ESS      ess)
maybe_add_directory(OPENSSL_NO_HTTP     http)
maybe_add_directory(OPENSSL_NO_OCSP     ocsp)
maybe_add_directory(OPENSSL_NO_TS       ts)

# Source files
set(SOURCE
    asn1_dsa.c bsearch.c context.c core_algorithm.c core_fetch.c
    core_namemap.c cpt_err.c cryptlib.c cversion.c der_writer.c
    deterministic_nonce.c ebcdic.c ex_data.c getenv.c info.c init.c
    initthread.c mem.c mem_sec.c o_dir.c o_fopen.c o_init.c o_str.c
    o_time.c packet.c param_build.c param_build_set.c params.c params_dup.c
    params_from_text.c params_idx.c passphrase.c provider.c provider_child.c
    provider_conf.c provider_core.c provider_predefined.c punycode.c
    self_test_core.c sleep.c sparse_array.c threads_lib.c threads_none.c
    threads_pthread.c threads_win.c time.c time.c trace.c uid.c
    )

add_dependencies(crypto buildinf)

macro (assembly_file plfile sfile deps)
    add_custom_command(COMMENT "Generating ${sfile}"
        OUTPUT ${sfile}
        DEPENDS ${deps}
        )
endmacro ()

# CPUID assembler modules include OPENSSL_cleanse
set(FOUND "")
if (NOT OPENSSL_NO_ASM)
    if (${ARCH} STREQUAL "x86")
        set(FOUND x86cpuid.S)
        generate_asm_from_perl(x86cpuid.S x86cpuid.pl)
    elseif (${ARCH} STREQUAL "x86_64")
        set(FOUND x86_64cpuid.s)
        generate_asm_from_perl(x86_64cpuid.s x86_64cpuid.pl)
    elseif (${ARCH} STREQUAL "sparcv9")
        set(FOUND sparcv9cap.c sparccpuid.S)
    elseif (${ARCH} STREQUAL "alpha")
        set(FOUND alphacpuid.s)
        generate_asm_from_perl(alphacpuid.s alphacpuid.pl)
    elseif (${ARCH} STREQUAL "s390x")
        set(FOUND s390xcap.c s390xcpuid.S)
        generate_asm_from_perl(s390xcpuid.S s390xcpuid.pl)
    elseif (${ARCH} STREQUAL "armv4")
        set(FOUND armcap.c armv4cpuid.S)
        generate_asm_from_perl(arm64cpuid.S arm64cpuid.pl)
    elseif (${ARCH} STREQUAL "aarch64")
        set(FOUND armcap.c arm64cpuid.S)
    elseif (${ARCH} STREQUAL "ppc32" OR "${ARCH}" STREQUAL "ppc64")
        set(FOUND ppccpuid.s ppccap.c)
        generate_asm_from_perl(ppccpuid.s ppccpuid.pl)
    elseif (${ARCH} STREQUAL "risc64")
        set(FOUND riscvcap.c riscv64cpuid.s)
        generate_asm_from_perl(riscv64cpuid.s riscv64cpuid.pl)
    elseif (${ARCH} STREQUAL "riscv32")
        set(FOUND riscvcap.c riscv32cpuid.s)
        generate_asm_from_perl(riscv32cpuid.s riscv32cpuid.pl)
    elseif (${ARCH} STREQUAL "loongarch64")
        set(FOUND loongarchcap.c loongarch64cpuid.s)
        generate_asm_from_perl(loongarch64cpuid.s loongarch64cpuid.pl)
    endif ()
endif ()
if (FOUND)
    list(APPEND SOURCE ${FOUND})
    target_compile_definitions(crypto PUBLIC OPENSSL_CPUID_OBJ)
else ()
    list(APPEND SOURCE cpuid.c ctype.c mem_clr.c)
endif ()

if (NOT OPENSSL_NO_STATIC_ENGINE)
    include(../engines/EngineLib.cmake)
    engines_for_crypto_lib()
endif ()

# Uplink/applink
if (OPENSSL_DO_UPLINK)
    list(APPEND SOURCE ../ms/uplink.c)
    if ({$ARCH} STREQUAL "x86")
        list(APPEND SOURCE uplink-x86.S)
        generate_asm_from_perl(uplink-x86.S ../ms/uplink-x86.pl)
    elseif (${ARCH} STREQUAL "x86_64")
        list(APPEND SOURCE uplink_x86_64.s)
        generate_asm_from_perl(uplink-x86_64.s ../ms/uplink-x86_64.pl)
    else ()
        list(APPEND SOURCE ../ms/uplink.c)
    endif ()
endif ()

# Generate buildinf since the string is too long for standard C
set(mkbuildinf ${CMAKE_SOURCE_DIR}/crypto/mkbuildinf.pl)
set(out ${CMAKE_BINARY_DIR}/include/internal/buildinf.h)
add_custom_command(COMMENT "Generating ${out}"
    OUTPUT  ${out} DEPENDS ${mkbuildinf}
    COMMAND ${PERL} ${mkbuildinf}
        ${out} "${BUILD_DATE}" "${ARCH}" "${CC} ${LDFLAGS} ${CPPFLAGS}"
    VERBATIM)
add_custom_target(buildinf COMMENT "Generated headers"
    DEPENDS ${out})
add_dependencies(crypto buildinf)

target_sources(crypto PRIVATE ${SOURCE})

foreach (SD ${SUBDIRS})
    add_subdirectory(${SD})
endforeach ()
