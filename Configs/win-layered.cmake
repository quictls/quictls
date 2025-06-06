## MinGW
macro(base_mingw)
    base_unix()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3)
    add_definitions(UNICODE _UNICODE WIN32_LEAN_AND_MEAN _MT)
    target_link_libraries(crypto -lws2_32 -lgdi32 -lcrypt32)
    set(OPENSSL_THREADS_WINNT 1)
    set(DSO_SCHEME_WIN32 1)
endmacro ()

macro(mingw)
    base_mingw()
    set(CFLAGS_RELEASE ${CFLAGS_RELEASE} -fomit-frame-pointer)
    set(CFLAGS -m32)
    set(BN_LLONG 1)
    set(UPLINK_ARCH x86)
    set(PERLASM_SCHEME coff)
endmacro ()

# Applink not supported because until it supports structured
# structured exception handling, one can't seriously
# consider its binaries for using with non-mingw64 run-time
macro(mingw64)
    base_mingw()
    set(CFLAGS -m64)
    set(SIXTY_FOUR_BIT 1)
    set(PERLASM_SCHEME mingw64)
endmacro ()

## Cygwin
macro(base_cygwin)
    base_unix()
    set(CFLAGS_DEBUG -Wall -O0 -g)
    set(CFLAGS_RELEASE -Wall -O3)
    target_link_libraries(crypto -lcrypt32)
    add_definitions(TERMIOS)
endmacro ()

macro(cygwin_x86)
    base_cygwin()
    set(CFLAGS_RELEASE ${CFLAGS_RELEASE} -fomit-frame-pointer)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME coff)
endmacro ()

macro(cygwin_x86_64)
    base_cygwin()
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME mingw64)
endmacro ()
