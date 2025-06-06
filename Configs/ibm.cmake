macro(os390_unix)
    base_unix()
    set(CFLAGS -O -DCHARSET_EBCDIC)
    set(THIRTY_TWO_BIT 1)
    set(RC4_CHAR 1)
    set(OPENSSL_NO_THREADS 1)
endmacro ()

macro(base_aix)
    base_unix()
    add_link_options(-Wl,-bsvr4)
endmacro ()

macro(aix_gcc)
    base_aix()
    set(CFLAGS_DEBUG -O0 -g)
    set(CFLAGS_RELEASE -O)
    #? cflags => add(threads("-pthread")),
    target_link_libraries(crypto -pthread)
    set(BN_LLONG 1)
    set(RC4_CHAR 1)
    set(PERLASM_SCHEME aix32)
endmacro ()

macro(aix64_gcc)
    base_aix()
    set(CFLAGS_DEBUG -O0 -g)
    set(CFLAGS_RELEASE -O)
    #? cflags => combine("-maix64", threads("-pthread")),
    target_link_libraries(crypto -pthread)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(RC4_CHAR 1)
    set(PERLASM_SCHEME aix64)
    #? AR => add("-X64"),
    #? RANLIB => add("-X64"),
endmacro ()

macro(aix64_gcc_as)
    aix64_gcc()
    set(PERLASM_SCHEME aix64-as)
endmacro ()

macro(aix_cc)
    base_aix()
    set(CFLAGS_DEBUG -O0 -g)
    set(CFLAGS_RELEASE -O)
    #? cflags => combine("-q32 -qmaxmem=16384 -qro -qroconst",
    #?                   threads("-qthreaded")),
    add_definitions(_THREAD_SAFE)
    target_link_libraries(crypto -lpthreads)
    set(BN_LLONG 1)
    set(RC4_CHAR 1)
    set(PERLASM_SCHEME aix32)
endmacro ()

macro(aix64_cc)
    base_aix()
    set(CFLAGS_DEBUG -O0 -g)
    set(CFLAGS_RELEASE -O)
    #? cflags => combine("-q64 -qmaxmem=16384 -qro -qroconst",
    #?                   threads("-qthreaded")),
    add_definitions(_THREAD_SAFE)
    target_link_libraries(crypto -lpthreads)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(RC4_CHAR 1)
    set(PERLASM_SCHEME aix64)
endmacro ()

macro(aix64_cc_solib)
    aix64_cc()
endmacro ()
