set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(rc5asm_x86 rc5-586.S)

    look_for_assembler(rc5 crypto RC5_ASM)
endif ()

if (NOT FOUND)
    list(APPEND SOURCE rc5_enc.c)
endif ()

list(APPEND SOURCE rc5_skey.c rc5_ecb.c rc5cfb64.c rc5ofb64.c)

generate_asm_from_perl(rc5-586.S asm/rc5-586.pl)
#DEPEND[rc5-586.S]=../perlasm/x86asm.pl ../perlasm/cbc.pl
target_sources(crypto PRIVATE ${SOURCE})
