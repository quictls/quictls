set(SOURCE)

if (NOT OPENSSL_NO_ASM)
    set(chachaasm_x86 chacha-x86.S)
    set(chachaasm_x86_64 chacha-x86_64.s)
    set(chachaasm_s390x chacha-s390x.S)
    set(chachaasm_armv4 chacha-armv4.S)
    set(chachaasm_aarch64 chacha-armv8.S chacha-armv8-sve.S)
    set(chachaasm_loongarch64 chacha-loongarch64.S)
    set(chachaasm_ppc32 chacha_ppc.c chacha-ppc.s)
    if ( NOT (${CMAKE_SYSTEM_NAME} STREQUAL "AIX"
        OR $CMAKE_SYSTEM_NAME} STREQUAL "Darwin"))
        set(chachaasm_ppc32 chacha_ppc.c chacha-ppc.s chachap10-ppc.s)
    endif ()
    set(chachaasm_ppc64 ${chachaasm_ppc32})
    set(chachaasm_riscv64 chacha_riscv.c chacha_enc.c chacha-riscv64-zvkb.s)
    look_for_assembler(chacha crypto "")
    if (${ARCH} STREQUAL "riscv64")
        target_compile_definitions(crypto PUBLIC INCLUDE_C_CHACHA20)
    endif ()
endif ()

if (NOT FOUND)
    list(APPEND SOURCE chacha_enc.c)
endif ()

generate_asm_from_perl(chacha-armv4.S asm/chacha-armv4.pl)
generate_asm_from_perl(chacha-armv8.S asm/chacha-armv8.pl)
generate_asm_from_perl(chacha-armv8-sve.S asm/chacha-armv8-sve.pl)
generate_asm_from_perl(chacha-loongarch64.S asm/chacha-loongarch64.pl)
generate_asm_from_perl(chacha-s390x.S asm/chacha-s390x.pl)
generate_asm_from_perl(chacha-x86.S asm/chacha-x86.pl)
#GENERATE[chachap10-ppc.s]=asm/chachap10-ppc.pl
#GENERATE[chacha-ppc.s]=asm/chacha-ppc.pl
#GENERATE[chacha-riscv64-zvkb.s]=asm/chacha-riscv64-zvkb.pl
#GENERATE[chacha-x86_64.s]=asm/chacha-x86_64.pl
target_sources(crypto PRIVATE ${SOURCE})
