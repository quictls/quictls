# *-generic* is endian-neutral target, but ./config is free to
# throw in -D[BL]_ENDIAN, whichever appropriate...
macro(linux_generic32)
    base_unix()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3)
    #? cflags => threads("-pthread"),
    #add_definitions(OPENSSL_USE_NODELETE)
    set(RC4_CHAR 1)
    unset(OPENSSL_NO_AFALGENG)
endmacro ()

macro(linux_latomic)
    linux_generic32()
    target_link_libraries(crypto -latomic)
endmacro ()

macro(linux_generic64)
    linux_generic32()
    set(SIXTY_FOUR_BIT_LONG 1)
    set(RC4_CHAR 1)
endmacro ()

macro(linux_ppc)
    linux_latomic()
    set(PERLASM_SCHEME linux32)
endmacro ()

macro(linux_ppc64)
    linux_generic64()
    set(CFLAGS ${CFLAGS} -m64)
    set(PERLASM_SCHEME linux64)
endmacro ()

macro(linux_ppc64le)
    linux_generic64()
    set(CFLAGS ${CFLAGS} -m64)
    set(PERLASM_SCHEME linux64le)
endmacro ()

# Note that -march is not among compiler options in linux-armv4
# target description. Not specifying one is intentional to give
# you choice to:
#
# a) rely on your compiler default by not specifying one;
# b) specify your target platform explicitly for optimal
# performance, e.g. -march=armv6 or -march=armv7-a;
# c) build "universal" binary that targets *range* of platforms
# by specifying minimum and maximum supported architecture;
#
# As for c) option. It actually makes no sense to specify
# maximum to be less than ARMv7, because it's the least
# requirement for run-time switch between platform-specific
# code paths. And without run-time switch performance would be
# equivalent to one for minimum. Secondly, there are some
# natural limitations that you'd have to accept and respect.
# Most notably you can *not* build "universal" binary for
# big-endian platform. This is because ARMv7 processor always
# picks instructions in little-endian order. Another similar
# limitation is that -mthumb can't "cross" -march=armv6t2
# boundary, because that's where it became Thumb-2. Well, this
# limitation is a bit artificial, because it's not really
# impossible, but it's deemed too tricky to support. And of
# course you have to be sure that your binutils are actually
# up to the task of handling maximum target platform. With all
# this in mind here is an example of how to configure
# "universal" build:
#
# ./Configure linux-armv4 -march=armv6 -D__ARM_MAX_ARCH__=8
macro(linux_armv4)
    linux_latomic()
    set(PERLASM_SCHEME linux32)
endmacro ()

macro(linux_aarch64)
    linux_generic64()
    set(PERLASM_SCHEME linux64)
endmacro ()

macro(linux_arm64ilp32)
    linux_generic32()
    set(CFLAGS ${CFLAGS} -mabi=ilp32)
    set(SIXTY_FOUR_BIT 1)
    set(RC4_CHAR 1)
    set(PERLASM_SCHEME linux64)
endmacro ()

macro(linux64_riscv64)
    linux_generic64()
    set(PERLASM_SCHEME linux64)
endmacro ()

macro(linux32_riscv32)
    linux_latomic()
    set(PERLASM_SCHEME linux32)
endmacro ()

macro(linux64_loongarch64)
    linux_generic64()
    set(PERLASM_SCHEME linux64)
endmacro ()

macro(linux_elf)
    linux_generic32()
    set(CFLAGS_RELEASE ${CFLAGS_RELEASE} -fomit-frame-pointer)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()

macro(linux_aout)
    base_unix()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3 -fomit-frame-pointer)
    set(BN_LLONG 1)
    set(OPENSSL_NO_THREADS 1)
    set(PERLASM_SCHEME a.out)
endmacro ()

macro(linux_x86)
    linux_generic32()
    set(CFLAGS_RELEASE ${CFLAGS_RELEASE} -fomit-frame-pointer)
    set(CFLAGS ${CFLAGS} -m32)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()

macro(linux_x86_latomic)
    linux_x86()
    target_link_libraries(crypto -latomic)
endmacro ()

macro(linux_x86_clang)
    linux_x86()
    target_link_libraries(crypto -latomic)
endmacro ()

macro(linux_x86_64)
    linux_generic64()
    set(CFLAGS ${CFLAGS} -m64)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()

macro(linux_x86_64_clang)
    linux_x86_64()
endmacro ()

macro(linux_x32)
    linux_generic32()
    set(CFLAGS ${CFLAGS} -m32)
    set(SIXTY_FOUR_BIT 1)
    set(PERLASM_SCHEME elf32)
endmacro ()

macro(linux64_s390x)
    linux_generic64()
    set(CFLAGS ${CFLAGS} -m64)
    set(PERLASM_SCHEME 64)
endmacro ()

# So called "highgprs" target for z/Architecture CPUsm a kernel
# Linux 2.6.32, see /proc/cpuinfo.
macro(linux32_s390x)
    linux_generic32()
    set(CFLAGS ${CFLAGS} -m31 -Wa,-mzarch)
    set(PERLASM_SCHEME 31)
endmacro ()

## SPARC Linux setups
macro(linux_sparcv8)
    linux_latomic()
    set(CFLAGS ${CFLAGS} -mcpu=v8)
    add_definitions(BN_DIV2W)
    set(PERLASM_SCHEME void)
endmacro ()

macro(linux_sparcv9)
    # it's a real mess with -mcpu=ultrasparc option under Linux,
    # but -Wa,-Av8plus should do the trick no matter what.
    linux_latomic()
    set(CFLAGS ${CFLAGS} -m32 -mcpu=ultrasparc -Wa,-Av8plus)
    add_definitions(BN_DIV2W)
    set(PERLASM_SCHEME void)
endmacro ()

macro(linux64_sparcv9)
    linux_generic64()
    set(CFLAGS ${CFLAGS} -m64 -mcpu=ultrasparc)
    target_link_libraries(crypto -latomic)
    set(BN_LLONG 1)
    set(RC4_CHAR 1)
    set(PERLASM_SCHEME void)
endmacro ()

macro(linux_alpha_gcc)
    linux_generic64()
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME void)
endmacro ()
