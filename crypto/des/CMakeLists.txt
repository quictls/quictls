set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(desasm_x86 des-586.S crypt586.S)
    set(desasm_sparcv9 des_enc-sparc.S fcrypt_b.c dest4-sparcv9.S)
    set(desasm_sparcv8 des_enc-sparc.S fcrypt_b.c)
    look_for_assembler(des crypto DES_ASM)
endif ()

if (NOT FOUND)
    list(APPEND SOURCE des_enc.c fcrypt_b.c)
endif ()

list(APPEND SOURCE
    set_key.c ecb3_enc.c ecb_enc.c cbc_enc.c cfb64enc.c cfb64ede.c
    cfb_enc.c ofb64ede.c ofb64enc.c ofb_enc.c str2key.c pcbc_enc.c
    qud_cksm.c rand_key.c fcrypt.c xcbc_enc.c cbc_cksm.c
    )

generate_asm_from_perl(dest4-sparcv9.S asm/dest4-sparcv9.pl)
generate_asm_from_perl(des-586.S asm/des-586.pl)
generate_asm_from_perl(crypt586.S asm/crypt586.pl)
generate_asm_from_m4(des_enc-sparc.S asm/des_enc.m4)
target_sources(crypto PRIVATE ${SOURCE})
