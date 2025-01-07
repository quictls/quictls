set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(wpasm_x86 wp_block.c whrlpool/asm/wp-mmx.S)
    set(wpasm_x86_64 asm/wp-x86_64.s)
    look_for_assembler(wp crypto WHIRLPOOL_ASM)
endif ()

list(APPEND SOURCE wp_dgst.c)

generate_asm_from_perl(wp-mmx.S asm/wp-mmx.pl)
#DEPEND[wp-mmx.S]=../perlasm/x86asm.pl
#GENERATE[wp-x86_64.s]=asm/wp-x86_64.pl
target_sources(crypto PRIVATE ${SOURCE})
