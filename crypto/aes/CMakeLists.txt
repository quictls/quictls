set(SOURCE)
if (NOT OPENSSL_NO_ASM)
    set(aesasm_x86 asm/aes-586.S)
    set(aesdef_x86 AES_ASM)
    if (NOT OPENSSL_NO_SSE2)
        list(APPEND aesasm_x86 asm/vpaes-x86.S asm/aesni-x86.S)
        list(APPEND aesdef_x86 VPAES_ASM OPENSSL_IA32_SSE2)
    endif ()

    set(aesasm_x86_64
        asm/aes-x86_64.s asm/vpaes-x86_64.s asm/bsaes-x86_64.s
        asm/aesni-x86_64.s asm/aesni-sha1-x86_64.s
        asm/aesni-sha256-x86_64.s asm/aesni-mb-x86_64.s
        )
    set(aesdef_x86_64 AES_ASM VPAES_ASM BSAES_ASM)

    set(aesasm_sparcv9
        asm/aes_core.c asm/aes_cbc.c
        asm/aes-sparcv9.S asm/aest4-sparcv9.S aesfx-sparcv9.S
        )
    set(aesdef_sparcv9 AES_ASM)

  set(aesasm_mips32 asm/aes_cbc.c asm/es-mips.S)
  set(aesdef_mips32 AES_ASM)
  set(aesasm_mips64 ${aesasm_mips32})
  set(aesdef_mips64 ${aesdef_mips32})

  # aes-390x.S implements AES_ctr32_encrypt and AES_xts_[en|de]crypt
  set(aesasm_s390x asm/aes-s390x.S)
  set(aesdef_s390x AES_ASM AES_CTR_ASM AES_XTS_ASM)

  set(aesasm_armv4 asm/aes_cbc.c asm/es-armv4.S
      asm/saes-armv7.S asm/esv8-armx.S)
  set(aesdef_armv4 AES_ASM BSAES_ASM)
  set(aesasm_aarch64 asm/aes_core.c asm/es_cbc.c
      asm/esv8-armx.S asm/saes-armv8.S vasm/paes-armv8.S)
  set(aesdef_aarch64 BSAES_ASM VPAES_ASM)

  if ( NOT (${CMAKE_SYSTEM_NAME} STREQUAL "AIX"
      OR $CMAKE_SYSTEM_NAME} STREQUAL "Darwin"))
      set(aesasm_ppc32 asm/aes_core.c asm/es_cbc.c
          asm/es-ppc.s vasm/paes-ppc.s asm/esp8-ppc.s)
  elseif ()
      set(aesasm_ppc32 asm/aes_core.c asm/es_cbc.c
          asm/es-ppc.s vasm/paes-ppc.s)
  endif ()
  set(aesdef_ppc32 AES_ASM VPAES_ASM)
  set(aesasm_ppc64 ${aesasm_ppc32})
  set(aesdef_ppc64 ${aesdef_ppc32})

  set(aesasm_riscv64 asm/aes_cbc.c asm/es-riscv64.s
      asm/es-riscv64-zkn.s asm/es-riscv64-zvkb-zvkned.s
      asm/es-riscv64-zvkned.s asm/es-riscv64-zvbb-zvkg-zvkned.s)
  set(aesdef_riscv64 AES_ASM)
  set(aesasm_riscv32 asm/aes_core.c asm/es_cbc.c
      asm/es-riscv32-zkn.s)

  set(aesasm_loongarch64 asm/aes_core.c
      aes_cbc.c vasm/paes-loongarch64.S)
  set(aesdef_loongarch64 VPAES_ASM)

  look_for_assembler(aes crypto "${aesdef_${ARCH}}")
endif ()
if (NOT FOUND)
    list(APPEND SOURCE aes_core.c aes_cbc.c)
endif ()

list(APPEND SOURCE aes_misc.c aes_ecb.c aes_cfb.c aes_ofb.c aes_wrap.c)
if (NOT OPENSSL_NO_DEPRECATED_3_0)
    list(APPEND SOURCE aes_ige.c)
endif ()

generate_asm_from_perl(bsaes-armv8.S asm/bsaes-armv8.pl)
generate_asm_from_perl(aes-586.S asm/aes-586.pl)
generate_asm_from_perl(vpaes-x86.S asm/vpaes-x86.pl)
generate_asm_from_perl(aesni-x86.S asm/aesni-x86.pl)
generate_asm_from_perl(aes-sparcv9.S asm/aes-sparcv9.pl)
generate_asm_from_perl(aest4-sparcv9.S asm/aest4-sparcv9.pl)
generate_asm_from_perl(aesfx-sparcv9.S asm/aesfx-sparcv9.pl)
generate_asm_from_perl(aes-mips.S asm/aes-mips.pl)
generate_asm_from_perl(aesv8-armx.S asm/aesv8-armx.pl)
generate_asm_from_perl(vpaes-armv8.S asm/vpaes-armv8.pl)
generate_asm_from_perl(aes-armv4.S asm/aes-armv4.pl)
generate_asm_from_perl(bsaes-armv7.S asm/bsaes-armv7.pl)
generate_asm_from_perl(vpaes-loongarch64.S asm/vpaes-loongarch64.pl)

#DEPEND[aes-586.S]=../perlasm/x86asm.pl
#DEPEND[aesni-586.S]=../perlasm/x86asm.pl
#DEPEND[aest4-sparcv9.S]=../perlasm/sparcv9_modes.pl
#DEPEND[vpaes-586.S]=../perlasm/x86asm.pl
#GENERATE[aesni-mb-x86_64.s]=asm/aesni-mb-x86_64.pl
#GENERATE[aesni-sha1-x86_64.s]=asm/aesni-sha1-x86_64.pl
#GENERATE[aesni-sha256-x86_64.s]=asm/aesni-sha256-x86_64.pl
#GENERATE[aesni-x86_64.s]=asm/aesni-x86_64.pl
#GENERATE[aesp8-ppc.s]=asm/aesp8-ppc.pl
#GENERATE[aes-ppc.s]=asm/aes-ppc.pl
#GENERATE[aes-riscv32-zkn.s]=asm/aes-riscv32-zkn.pl
#GENERATE[aes-riscv64.s]=asm/aes-riscv64.pl
#GENERATE[aes-riscv64-zkn.s]=asm/aes-riscv64-zkn.pl
#GENERATE[aes-riscv64-zvbb-zvkg-zvkned.s]=asm/aes-riscv64-zvbb-zvkg-zvkned.pl
#GENERATE[aes-riscv64-zvkb-zvkned.s]=asm/aes-riscv64-zvkb-zvkned.pl
#GENERATE[aes-riscv64-zvkned.s]=asm/aes-riscv64-zvkned.pl
#GENERATE[aes-x86_64.s]=asm/aes-x86_64.pl
#GENERATE[bsaes-x86_64.s]=asm/bsaes-x86_64.pl
#GENERATE[vpaes-ppc.s]=asm/vpaes-ppc.pl
#GENERATE[vpaes-x86_64.s]=asm/vpaes-x86_64.pl
target_sources(crypto PRIVATE ${SOURCE})
