set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(rc4asm_x86 rc4-586.S)
    set(rc4asm_x86_64 rc4-x86_64.s rc4-md5-x86_64.s)
    set(rc4asm_s390x rc4-s390x.s)
    look_for_assembler(rc4 crypto RC4_ASM)
endif ()

list(APPEND SOURCE rc4_enc.c rc4_skey.c)

generate_asm_from_perl(rc4-586.S asm/rc4-586.pl)
#DEPEND[rc4-586.S]=../perlasm/x86asm.pl
#GENERATE[rc4-x86_64.s]=asm/rc4-x86_64.pl
#GENERATE[rc4-md5-x86_64.s]=asm/rc4-md5-x86_64.pl
#GENERATE[rc4-s390x.s]=asm/rc4-s390x.pl
target_sources(crypto PRIVATE ${SOURCE})
