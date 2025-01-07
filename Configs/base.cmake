macro (cfg_add_define flag setting)
    if (NOT ${flag})
        add_definitions(${setting})
    endif ()
endmacro ()

macro (cfg_add_include path)
    if (NOT ${path})
        include_directories(${path})
    endif ()
endmacro ()

macro (cfg_add_libraries libs)
    if (${libs})
        target_link_libraries(crypto ${libs})
    endif ()
endmacro ()

macro (base)
    cfg_add_define(OPENSSL_NO_BROTLI BROTLI)
    cfg_add_define(OPENSSL_NO_BROTLI_DYNAMIC BROTLI_SHARED)
    cfg_add_include(BROTLI_INCLUDE)
    cfg_add_libraries(BROTLI_LIBS)

    cfg_add_define(OPENSSL_NO_ZLIB ZLIB)
    cfg_add_define(OPENSSL_NO_ZLIB_DYNAMIC ZLIB_SHARED)
    cfg_add_include(ZLIB_INCLUDE)
    cfg_add_libraries(ZLIB_LIBS)

    cfg_add_define(OPENSSL_NO_ZSTD ZSTD)
    cfg_add_define(OPENSSL_NO_ZSTD_DYNAMIC ZSTD_SHARED)
    cfg_add_include(ZSTD_INCLUDE)
    cfg_add_libraries(ZSTD_LIBS)
endmacro ()

macro (base_unix)
    base()
    set(OPENSSL_THREADS_POSIX 1)
    set(DSO_SCHEME_DLFCN 1)
    set(OPENSSL_NO_STATIC_ENGINE 1)
endmacro ()

set(GCC_STRICT_WARNINGS
    -Wall -pedantic -Wno-long-long -Wmissing-declarations -Wextra
    -Wno-unused-parameter -Wno-missing-field-initializers -Wswitch
    -Wsign-compare -Wshadow -Wformat -Wno-type-limits -Wundef -Werror
    -Wmissing-prototypes -Wstrict-prototypes
    )
set(GCC_STRICT_DEFS PEDANTIC UNUSEDRESULT_DEBUG)

set(CLANG_STRICT_WARNINGS ${GCC_STRICT_WRARNINGS})
list(APPEND CLANG_STRICT_WARNINGS
    -Wno-unknown-warning-option -Wno-parentheses-equality
    -Wno-language-extension-token -Wno-extended-offsetof
    -Wno-missing-braces -Wno-tautological-constant-out-of-range-compare
    -Wconditional-uninitialized -Wincompatible-pointer-types-discards-qualifiers
    -Wmissing-variable-declarations
    )
set(CLANG_STRICT_DEFS ${GCC_STRICT_DEFS})
