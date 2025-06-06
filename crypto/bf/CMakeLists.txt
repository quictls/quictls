set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(bfasm_x86 bf-586.S)
    look_for_assembler(bf crypto BF_ASM)
endif ()

if (NOT FOUND)
    list(APPEND SOURCE bf_enc.c)
endif ()

list(APPEND SOURCE bf_skey.c bf_ecb.c bf_cfb64.c bf_ofb64.c)

generate_asm_from_perl(bf-586.S asm/bf-586.pl)
#DEPEND[bf-586.S]=../perlasm/x86asm.pl ../perlasm/cbc.pl
target_sources(crypto PRIVATE ${SOURCE})
