set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(poly1305asm_x86 gasm/poly1305-x86.S)
    set(poly1305asm_x86_64 asm/poly1305-x86_64.s)
    set(poly1305asm_sparcv9 gasm/poly1305-sparcv9.S)
    set(poly1305asm_mips64 gasm/poly1305-mips.S)
    set(poly1305asm_s390x gasm/poly1305-s390x.S)
    set(poly1305asm_armv4 gasm/poly1305-armv4.S)
    set(poly1305asm_aarch64 gasm/poly1305-armv8.S)
    set(poly1305asm_ppc32 gasm/poly1305_ppc.c
        gasm/poly1305-ppc.s poly1305/asm/poly1305-ppcfp.s)
    set(poly1305asm_ppc64 ${poly1305asm_ppc32})
    look_for_assembler(poly1305 crypto POLY1305_ASM)
endif ()

list(APPEND SOURCE poly1305.c)

generate_asm_from_perl(poly1305-armv4.S asm/poly1305-armv4.pl)
generate_asm_from_perl(poly1305-armv8.S asm/poly1305-armv8.pl)
generate_asm_from_perl(poly1305-mips.S asm/poly1305-mips.pl)
generate_asm_from_perl(poly1305-s390x.S asm/poly1305-s390x.pl)
generate_asm_from_perl(poly1305-sparcv9.S asm/poly1305-sparcv9.pl)
generate_asm_from_perl(poly1305-x86.S asm/poly1305-x86.pl)
#GENERATE[poly1305-ppcfp.s]=asm/poly1305-ppcfp.pl
#GENERATE[poly1305-ppc.s]=asm/poly1305-ppc.pl
#GENERATE[poly1305-x86_64.s]=asm/poly1305-x86_64.pl
target_sources(crypto PRIVATE ${SOURCE})
