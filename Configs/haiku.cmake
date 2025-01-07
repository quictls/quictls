macro (base_haiku)
    set(PERLASM_SCHEME elf)
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O2)
    set(CFLAGS -include ${CMAKE_SOURCE_DIR}/os-dep/haiku.h ${CFLAGS})
    #threads("-D_REENTRANT")),
    #ex_libs          => "-lnetwork",
    #thread_scheme    => "pthreads",
endmacro ()

macro (haiku_x86)
    base_haiku()
    set(CFLAGS_RELEASE ${CFLAGS_RELEASE} -fomit-frame-pointer)
    set(BN_LLONG 1)
endmacro ()

macro (haiku_x86_64)
    base_haiku()
    target_compiler_options(crypto -m64)
    set(SIXTY_FOUR_BIT_LONG 1)
endmacro ()
