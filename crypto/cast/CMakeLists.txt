set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    # NOT PIC set(castasm_x86 cast-586.S)
    look_for_assembler(cast crypto CAST_ASM)
endif ()

if (NOT FOUND)
    list(APPEND SOURCE c_enc.c)
endif ()

list(APPEND SOURCE c_skey.c c_ecb.c c_cfb64.c c_ofb64.c)

generate_asm_from_perl(cast-586.S asm/cast-586.pl)
#DEPEND[cast-586.S]=../perlasm/x86asm.pl ../perlasm/cbc.pl
target_sources(crypto PRIVATE ${SOURCE})
