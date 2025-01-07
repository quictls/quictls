## Solaris configurations
macro(base_solaris)
    base_unix()
    add_definitions(FILIO_H)
    target_link_libraries(crypto -lsocket -lnsl -ldl)
endmacro ()

# Solaris common with Sun C setups
macro(base_solaris_cc)
    base_solaris()
endmacro ()

# Solaris common with GNU C setups
macro(base_solaris_gcc)
    base_solaris()
endmacro ()

# Solaris x86 with GNU C setups
# NB. GNU C has to be configured to use GNU assembler, and not
# /usr/ccs/bin/as. Failure to comply will result in compile
# failures [at least] in 32-bit build.
macro(solaris_x86_gcc)
    base_solaris_gcc()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3 -fomit-frame-pointer)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()

macro(solaris64_x86_64_gcc)
    base_solaris_gcc()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3)
    set(CFLAGS ${CFLAGS} -m64)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()

# Solaris x86 with Sun C setups
macro(solaris64_x86_64_cc)
    base_solaris_cc()
    set(CFLAGS_DEBUG -g)
    set(CFLAGS_RELEASE -xO5 -xdepend -xbuiltin)
    set(CFLAGS -xarch=generic64 -xstrconst -Xa, ${CFLAGS})
    add_definitions(_REENTRANT)
    add_link_options(-mt)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME elf)
endmacro ()

# SPARC Solaris with GNU C setups
macro(solaris_sparcv7_gcc)
    base_solaris_gcc()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3)
    add_definitions(BN_DIV2W)
    set(BN_LLONG 1)
    set(RC4_CHAR 1)
endmacro ()

macro(solaris_sparcv8_gcc)
    solaris_sparcv7_gcc()
    set(CFLAGS -mcpu=v8 ${CFLAGS})
    set(PERLASM_SCHEME void)
endmacro ()

macro(solaris_sparcv9_gcc)
    solaris_sparcv7_gcc()
    set(CFLAGS -m32 -mcpu=ultrasparc ${CFLAGS})
    set(PERLASM_SCHEME void)
endmacro ()

macro(solaris64_sparcv9_gcc)
    solaris_sparcv9_gcc()
    set(CFLAGS -m64 -mcpu=ultrasparc ${CFLAGS})
    set(RC4_CHAR 1)
endmacro ()
