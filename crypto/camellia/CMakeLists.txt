set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(cmllasm_x86 asm/cmll-x86.S)
    set(cmllasm_x86_64 asm/cmll-x86_64.s cmll_misc.c)
    set(cmllasm_sparcv9 camellia.c cmll_misc.c cmll_cbc.c asm/cmllt4-sparcv9.S)
    look_for_assembler(cmll crypto CMLL_ASM)
endif ()

if (NOT FOUND)
    list(APPEND SOURCE camellia.c cmll_misc.c cmll_cbc.c)
endif ()

list(APPEND SOURCE cmll_ecb.c cmll_ofb.c cmll_cfb.c cmll_ctr.c)

generate_asm_from_perl(cmll-x86.S asm/cmll-x86.pl)
generate_asm_from_perl(cmllt4-sparcv9.S asm/cmllt4-sparcv9.pl)
#GENERATE[cmll-x86_64.s]=asm/cmll-x86_64.pl
target_sources(crypto PRIVATE ${SOURCE})
