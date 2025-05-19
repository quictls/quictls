set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(sha1asm_x86 asm/sha1-586.S asm/sha256-586.S asm/sha512-586.S)
    set(sha1def_x86 SHA1_ASM SHA256_ASM SHA512_ASM)
    set(sha1asm_x86_64 
        asm/sha1-x86_64.s asm/sha512-x86_64.s asm/sha1-mb-x86_64.s
        asm/sha256-mb-x86_64.s asm/sha256-x86_64.s)
    set(sha1def_x86_64 SHA1_ASM SHA256_ASM SHA512_ASM)
    set(sha1asm_sparcv9 sha1-sparcv9.S sha256-sparcv9.S sha512-sparcv9.S)
    set(sha1def_sparcv9 SHA1_ASM SHA256_ASM SHA512_ASM)
    set(sha1asm_alpha sha1-alpha.S)
    set(sha1def_alpha SHA1_ASM)
    set(sha1asm_mips32 sha1-mips.S sha256-mips.S)
    set(sha1def_mips32 SHA1_ASM SHA256_ASM)
    set(sha1asm_mips64 ${sha1asm_mips32} sha512-mips.S)
    set(sha1def_mips64 ${sha1def_mips32} SHA512_ASM)
    set(sha1asm_s390x sha1-s390x.S sha256-s390x.S sha512-s390x.S)
    set(sha1def_s390x SHA1_ASM SHA256_ASM SHA512_ASM)
    set(sha1asm_armv4 sha1-armv4-large.S sha256-armv4.S sha512-armv4.S)
    set(sha1def_armv4 SHA1_ASM SHA256_ASM SHA512_ASM)
    set(sha1asm_aarch64 sha1-armv8.S sha256-armv8.S sha512-armv8.S)
    set(sha1def_aarch64 SHA1_ASM SHA256_ASM SHA512_ASM)
    set(sha1asm_ppc32 
        sha_ppc.c sha1-ppc.s sha256-ppc.s sha512-ppc.s sha256p8-ppc.s
        sha512p8-ppc.s)
    set(sha1def_ppc32 SHA1_ASM SHA256_ASM SHA512_ASM)
    set(sha1asm_ppc64 ${sha1asm_ppc32})
    set(sha1def_ppc64 ${sha1def_ppc32})
    set(sha1asm_riscv64 sha_riscv.c
        sha256-riscv64-zvkb-zvknha_or_zvknhb.S sha512-riscv64-zvkb-zvknhb.S)
    set(sha1def_riscv64 SHA256_ASM INCLUDE_C_SHA256 SHA512_ASM INCLUDE_C_SHA512)
    look_for_assembler(sha1 crypto "${sha1def_${ARCH}}")
endif ()

if (NOT OPENSSL_NO_ASM)
    set(keccak1600_x86_64 asm/keccak1600-x86_64.s)
    set(keccak1600_s390x keccak1600-s390x.S)
    set(keccak1600_armv4 keccak1600-armv4.S)
    set(keccak1600_aarch64 keccak1600-armv8.S)
    set(keccak1600_ppc64 keccak1600-ppc64.s)

    look_for_assembler(keccak1600 crypto "")
endif ()

list(APPEND SOURCE
    sha1dgst.c sha256.c sha512.c sha3.c sha1_one.c keccak1600.c
    )

#DEPEND[sha1-586.S]=../perlasm/x86asm.pl
#DEPEND[sha256-586.S]=../perlasm/x86asm.pl
#DEPEND[sha512-586.S]=../perlasm/x86asm.pl
generate_asm_from_perl(keccak1600-armv4.S asm/keccak1600-armv4.pl)
generate_asm_from_perl(keccak1600-armv8.S asm/keccak1600-armv8.pl)
generate_asm_from_perl(keccak1600-s390x.S asm/keccak1600-s390x.pl)
generate_asm_from_perl(sha1-586.S asm/sha1-586.pl)
generate_asm_from_perl(sha1-alpha.S asm/sha1-alpha.pl)
generate_asm_from_perl(sha1-armv4-large.S asm/sha1-armv4-large.pl)
generate_asm_from_perl(sha1-armv8.S asm/sha1-armv8.pl)
generate_asm_from_perl(sha1-mips.S asm/sha1-mips.pl)
generate_asm_from_perl(sha1-s390x.S asm/sha1-s390x.pl)
generate_asm_from_perl(sha1-sparcv9a.S asm/sha1-sparcv9a.pl)
generate_asm_from_perl(sha1-sparcv9.S asm/sha1-sparcv9.pl)
generate_asm_from_perl(sha256-586.S asm/sha256-586.pl)
generate_asm_from_perl(sha256-armv4.S asm/sha256-armv4.pl)
generate_asm_from_perl(sha256-armv8.S asm/sha512-armv8.pl)
generate_asm_from_perl(sha256-mips.S asm/sha512-mips.pl)
generate_asm_from_perl(sha256-riscv64-zvkb-zvknha_or_zvknhb.S asm/sha256-riscv64-zvkb-zvknha_or_zvknhb.pl)
generate_asm_from_perl(sha256-s390x.S asm/sha512-s390x.pl)
generate_asm_from_perl(sha256-sparcv9.S asm/sha512-sparcv9.pl)
generate_asm_from_perl(sha512-586.S asm/sha512-586.pl)
generate_asm_from_perl(sha512-armv4.S asm/sha512-armv4.pl)
generate_asm_from_perl(sha512-armv8.S asm/sha512-armv8.pl)
generate_asm_from_perl(sha512-mips.S asm/sha512-mips.pl)
generate_asm_from_perl(sha512-riscv64-zvkb-zvknhb.S asm/sha512-riscv64-zvkb-zvknhb.pl)
generate_asm_from_perl(sha512-s390x.S asm/sha512-s390x.pl)
generate_asm_from_perl(sha512-sparcv9.S asm/sha512-sparcv9.pl)
#GENERATE[keccak1600-ppc64.s]=asm/keccak1600-ppc64.pl
#GENERATE[keccak1600-x86_64.s]=asm/keccak1600-x86_64.pl
#GENERATE[sha1-mb-x86_64.s]=asm/sha1-mb-x86_64.pl
#GENERATE[sha1-ppc.s]=asm/sha1-ppc.pl
#GENERATE[sha1-x86_64.s]=asm/sha1-x86_64.pl
#GENERATE[sha256-mb-x86_64.s]=asm/sha256-mb-x86_64.pl
#GENERATE[sha256p8-ppc.s]=asm/sha512p8-ppc.pl
#GENERATE[sha256-ppc.s]=asm/sha512-ppc.pl
#GENERATE[sha256-x86_64.s]=asm/sha512-x86_64.pl
#GENERATE[sha512p8-ppc.s]=asm/sha512p8-ppc.pl
#GENERATE[sha512-ppc.s]=asm/sha512-ppc.pl
#GENERATE[sha512-x86_64.s]=asm/sha512-x86_64.pl

## These are not yet used and do not support multi-squeeze
generate_asm_from_perl(keccak1600-avx2.S asm/keccak1600-avx2.pl)
generate_asm_from_perl(keccak1600-avx512.S asm/keccak1600-avx512.pl)
generate_asm_from_perl(keccak1600-avx512vl.S asm/keccak1600-avx512vl.pl)
generate_asm_from_perl(keccak1600-mmx.S asm/keccak1600-mmx.pl)
generate_asm_from_perl(keccak1600p8-ppc.S asm/keccak1600p8-ppc.pl)
generate_asm_from_perl(sha1-thumb.S asm/sha1-thumb.pl)
target_sources(crypto PRIVATE ${SOURCE})
