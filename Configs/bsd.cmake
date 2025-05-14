# As for thread cflag. Idea is to maintain "collective" set of
# flags, which would cover all BSD flavors. -pthread applies
# to them all, but is treated differently. OpenBSD expands is
# as -D_POSIX_THREAD -lc_r, which is sufficient. FreeBSD 4.x
# expands it as -lc_r, which has to be accompanied by explicit
# -D_THREAD_SAFE and sometimes -D_REENTRANT. FreeBSD 5.x
# expands it as -lc_r, which seems to be sufficient?

macro(bsd_generic32)
    base_unix()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3)
    add_definitions(_THREAD_SAFE _REENTRANT)
    target_link_libraries(crypto -pthread)
    unset(OPENSSL_NO_DEVCRYPTOENG)
    set(BN_LLONG 1)
endmacro ()

macro(bsd_generic64)
    bsd_generic32()
    set(SIXTY_FOUR_BIT_LONG 1)
endmacro ()

macro(bsd_x86)
    bsd_generic32()
    set(CLFAGS_RELEASE ${CFLAGS_RELEASE} -fomit-frame-pointer)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME a.out)
endmacro ()

macro(bsd_x86_elf)
    bsd_x86()
    set(PERLASM_SCHEME elf)
endmacro ()

macro(bsd_sparcv8)
    bsd_generic32()
    set(CFLAGS ${CFLAGS} -mcpu=v8)
    set(PERLASM_SCHEME void)
endmacro ()

macro(bsd_sparc64)
    bsd_generic64()
    add_definitions(MD32_REG_T=int)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME void)
endmacro ()

macro(bsd_x86_64)
    bsd_generic64()
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()

macro(bsd_aarch64)
    bsd_generic64()
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME linux64)
endmacro ()

macro(bsd_ppc)
    bsd_generic32()
    set(PERLASM_SCHEME linux32)
endmacro ()

macro(bsd_ppc64)
    bsd_generic64()
    set(PERLASM_SCHEME linux64)
endmacro ()

macro(bsd_ppc64le)
    bsd_generic64()
    set(PERLASM_SCHEME linux64le)
endmacro ()

macro(bsd_riscv64)
    bsd_generic64()
    set(PERLASM_SCHEME linux64)
endmacro ()

macro(bsd_riscv32)
    bsd_generic32()
    set(PERLASM_SCHEME linux32)
endmacro ()

# See comment about -march in linux.cmake file
# ./Configure BSD-armv4 -march=armv6 -D__ARM_MAX_ARCH__=8
macro(bsd_armv4)
    bsd_generic32()
    set(PERLASM_SCHEME linux32)
endmacro ()

macro(bsdi_elf_gcc)
    base_unix()
    set(CFLAGS_RELEASE -fomit-frame-pointer -O3 -Wall)
    add_definitions()
    target_link_libraries(crypto -ldl)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()

macro(bsd_nodef_generic32)
    base_unix()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3)
    #? cflags => threads("-pthread"),
    add_definitions(_THREAD_SAFE _REENTRANT)
    target_link_libraries(crypto -pthread)
    unset(OPENSSL_NO_DEVCRYPTOENG)
    set(BN_LLONG 1)
endmacro ()

macro(bsd_nodef_generic64)
    bsd_nodef_generic32()
    set(SIXTY_FOUR_BIT_LONG 1)
endmacro ()

macro(bsd_nodef_x86)
    bsd_nodef_generic32()
    set(CLFAGS_RELEASE ${CFLAGS_RELEASE} -fomit-frame-pointer)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME a.out)
endmacro ()

macro(bsd_nodef_x86_elf)
    bsd_nodef_x86()
    set(PERLASM_SCHEME elf)
endmacro ()

macro(bsd_nodef_sparcv8)
    bsd_nodef_generic32()
    set(CFLAGS ${CFLAGS} -mcpu=v8)
    set(PERLASM_SCHEME void)
endmacro ()

macro(bsd_nodef_sparc64)
    bsd_nodef_generic64()
    # -DMD32_REG_T=int doesn't actually belong in sparc64 target, it
    # simply *happens* to work around a compiler bug in gcc 3.3.3,
    # triggered by RIPEMD160 code.
    add_definitions(MD32_REG_T=int)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME void)
endmacro ()

macro(bsd_nodef_x86_64)
    bsd_nodef_generic64()
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()
