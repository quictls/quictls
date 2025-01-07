set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(sm3asm_aarch64 sm3-armv8.S)
    set(sm3asm_riscv64 sm3_riscv.c sm3-riscv64-zvksh.S)
    look_for_assembler(sm3 crypto OPENSSL_SM3_ASM)
endif ()

list(APPEND SOURCE sm3.c legacy_sm3.c)

generate_asm_from_perl(sm3-armv8.S asm/sm3-armv8.pl)
generate_asm_from_perl(sm3-riscv64-zvksh.S asm/sm3-riscv64-zvksh.pl)
target_sources(crypto PRIVATE ${SOURCE})
