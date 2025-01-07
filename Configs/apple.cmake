macro(base_darwin)
    base_unix()
    set(CFLAGS_DEBUG -O0 -g)
    set(CFLAGS_RELEASE -O3)
    add_definitions(_REENTRANT)
    add_link_options(-Wl,-search_paths_first)
    set(BN_LLONG 1)
    set(RC4_CHAR 1)
    set(PERLASM_SCHEME osx32)
endmacro ()

macro(darwin64_x86_64)
    base_darwin()
    set(CFLAGS ${CFLAGS} -Wall -arch x86_64)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME macosx)
endmacro ()

macro(darwin64_arm64)
    base_darwin()
    set(CFLAGS ${CFLAGS} -Wall -arch x86_64)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME ios64)
endmacro ()


macro(base_ios)
    base_darwin()
    set(OPENSSL_NO_SHARED 1)
    set(OPENSSL_NO_ASYNC 1)
endmacro ()

macro(ios_xcrun)
    base_ios()
    #?    CC               => "xcrun -sdk iphoneos cc",
    set(CFLAGS ${CFLAGS} -arch armv7 -fno-common)
    set(PERLASM_SCHEME ios32)
endmacro ()

macro(ios64_xcrun)
    base_ios()
    #?CC               => "xcrun -sdk iphoneos cc",
    set(CFLAGS ${CFLAGS} -arch arm64 -fno-common)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(RC4_CHAR 1)
    set(PERLASM_SCHEME ios64)
endmacro ()

macro(iossimulator_xcrun)
    base_ios()
    #?CC               => "xcrun -sdk iphonesimulator cc",
endmacro ()

macro(iossimulator_arm64_xcrun)
    base_ios()
    #?CC               => "xcrun -sdk iphonesimulator cc",
    set(CFLAGS ${CFLAGS} -arch arm64 -fno-common)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME ios64)
endmacro ()

macro(iossimulator_i386_xcrun)
    base_ios()
    #?CC               => "xcrun -sdk iphonesimulator cc",
    set(CFLAGS ${CFLAGS} -arch i386 -fno-common)
    set(BN_LLONG 1)
    set(PERLASM_SCHEME macosx)
endmacro ()

macro(iossimulator_x86_64_xcrun)
    base_ios()
    #?CC               => "xcrun -sdk iphonesimulator cc",
    set(CFLAGS ${CFLAGS} -arch x86_64 -fno-common)
    set(SIXTY_FOUR_BIT_LONG 1)
    set(PERLASM_SCHEME macosx)
endmacro ()

