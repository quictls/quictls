set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(modesasm_x86 ghash-x86.S)
    set(modesasm_x86_64 ghash-x86_64.s
        aesni-gcm-x86_64.s aes-gcm-avx512.s)
    set(modesasm_sparcv9 ghash-sparcv9.S)
    set(modesasm_alpha ghash-alpha.S)
    set(modesasm_s390x ghash-s390x.S)
    set(modesasm_armv4 ghash-armv4.S;ghashv8-armx.S)
    set(modesasm_aarch64 ghashv8-armx.S
        aes-gcm-armv8_64.S aes-gcm-armv8-unroll8_64.S)
    set(modesasm_ppc32 ghashp8-ppc.s)
    if ( NOT (${CMAKE_SYSTEM_NAME} STREQUAL "AIX"
            OR $CMAKE_SYSTEM_NAME} STREQUAL "Darwin"))
        set(modesasm_ppc64 ${modes_ppc32} aes-gcm-ppc.s)
    endif ()
    set(modesasm_riscv64 ghash-riscv64.s ghash-riscv64-zvkb-zvbc.s
        ghash-riscv64-zvkg.s aes-gcm-riscv64-zvkb-zvkg-zvkned.s)

    look_for_assembler(modes crypto GHASH_ASM)
endif ()

list(APPEND SOURCE
    cbc128.c ctr128.c cfb128.c ofb128.c gcm128.c ccm128.c xts128.c cts128.c
    ocb128.c siv128.c wrap128.c xts128gb.c
    )

#INCLUDE[gcm128.o]=..
generate_asm_from_perl(ghash-x86.S asm/ghash-x86.pl)
generate_asm_from_perl(ghash-sparcv9.S asm/ghash-sparcv9.pl)
generate_asm_from_perl(ghash-alpha.S asm/ghash-alpha.pl)
generate_asm_from_perl(ghash-armv4.S asm/ghash-armv4.pl)
generate_asm_from_perl(ghashv8-armx.S asm/ghashv8-armx.pl)
generate_asm_from_perl(aes-gcm-armv8_64.S asm/aes-gcm-armv8_64.pl)
generate_asm_from_perl(aes-gcm-armv8-unroll8_64.S asm/aes-gcm-armv8-unroll8_64.pl)
generate_asm_from_perl(ghash-s390x.S asm/ghash-s390x.pl)
#GENERATE[ghash-x86_64.s]=asm/ghash-x86_64.pl
#GENERATE[aesni-gcm-x86_64.s]=asm/aesni-gcm-x86_64.pl
#GENERATE[aes-gcm-avx512.s]=asm/aes-gcm-avx512.pl
#GENERATE[ghashp8-ppc.s]=asm/ghashp8-ppc.pl
#GENERATE[aes-gcm-ppc.s]=asm/aes-gcm-ppc.pl
#GENERATE[ghash-riscv64.s]=asm/ghash-riscv64.pl
#GENERATE[ghash-riscv64-zvkb-zvbc.s]=asm/ghash-riscv64-zvkb-zvbc.pl
#GENERATE[ghash-riscv64-zvkg.s]=asm/ghash-riscv64-zvkg.pl
#GENERATE[aes-gcm-riscv64-zvkb-zvkg-zvkned.s]=asm/aes-gcm-riscv64-zvkb-zvkg-zvkned.pl
target_sources(crypto PRIVATE ${SOURCE})
