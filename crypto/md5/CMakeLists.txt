set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(md5asm_x86 md5-586.S)
    set(md5asm_x86_64 md5-x86_64.s)
    set(md5asm_aarch64 md5-aarch64.S)
    set(md5asm_loongarch64 md5-loongarch64.S)
    set(md5asm_sparcv9 md5-sparcv9.S)
    look_for_assembler(md5 crypto MD5_ASM)
endif ()

list(APPEND SOURCE
    md5_dgst.c md5_one.c md5_sha1.c
    )

generate_asm_from_perl(md5-586.S asm/md5-586.pl)
generate_asm_from_perl(md5-aarch64.S asm/md5-aarch64.pl)
generate_asm_from_perl(md5-loongarch64.S asm/md5-loongarch64.pl)
generate_asm_from_perl(md5-sparcv9.S asm/md5-sparcv9.pl)
#GENERATE[md5-x86_64.s]=asm/md5-x86_64.pl
target_sources(crypto PRIVATE ${SOURCE})
