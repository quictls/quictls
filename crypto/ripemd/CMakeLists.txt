set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(rmd160asm_x86 rmd160/rmd-586.S)

    look_for_assembler(rmd160 crypto RMD160_ASM)
endif ()

list(APPEND SOURCE rmd_dgst.c rmd_one.c)

generate_asm_from_perl(rmd-586.S asm/rmd-586.pl)
#DEPEND[rmd-586.S]=../perlasm/x86asm.pl
target_sources(crypto PRIVATE ${SOURCE})
