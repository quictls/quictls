set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(sm4asm_aarch64 sm4-armv8.S vpsm4-armv8.S vpsm4_ex-armv8.S)
    set(sm4asm_riscv64 sm4-riscv64-zvksed.s)
    look_for_assembler(sm4 crypto SM4_ASM)
    if (${ARCH} STREQUAL "aarch64")
        target_compile_defintions(crypto PUBLIC VPSM4_ASM)
    endif ()
    generate_asm_from_perl(sm4-armv8.S asm/sm4-armv8.pl)
    generate_asm_from_perl(vpsm4-armv8.S asm/vpsm4-armv8.pl)
    generate_asm_from_perl(vpsm4_ex-armv8.S asm/vpsm4_ex-armv8.pl)
    #GENERATE[sm4-riscv64-zvksed.s]=asm/sm4-riscv64-zvksed.pl
endif ()

list(APPEND SOURCE sm4.c)

target_sources(crypto PRIVATE ${SOURCE})
