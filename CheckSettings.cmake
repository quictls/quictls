# Sanity-check settings

if (NOT DEFINED THIRTY_TWO_BIT
        AND NOT DEFINED BN_LLONG
        AND NOT DEFINED SIXTY_FOUR_BIT_LONG
        AND NOT DEFINED BN_LLONG)
    set(BN_LLONG 1)
    set(THIRTY_TWO_BIT 1)
endif ()

if (DEFINED RC4_CHAR AND DEFINED RC4_INT)
    message(FATAL_ERROR "Cannot define RC4 types")
endif ()
if (NOT DEFINED RC4_CHAR AND NOT DEFINED RC4_INT)
    set(RC4_INT 1)
endif ()
if (DEFINED RC4_CHAR)
    set(RC4_TYPE "unsigned char")
else ()
    set(RC4_TYPE "unsigned int")
endif ()

if (DEFINED OPENSSL_NO_FUZZ
        AND (DEFINED FUZZER_LIB OR DEFINED FUZZER_INC))
    message(WARNING "Fuzzers disabled but include or lib set")
endif()
macro (setdefault var value)
    if (NOT DEFINED ${var})
        set(${var} ${value})
        message(STATUS "Setting ${var} to ${value}")
    endif ()
endmacro ()

setdefault(INSTALLPREFIX "/usr/local")
setdefault(LIBSUBDIR "lib")
setdefault(OPENSSLDIR "${INSTALLPREFIX}/${LIBSUBDIR}/ssl")
setdefault(MODULESDIR "${INSTALLPREFIX}/${LIBSUBDIR}/ossl-modules")
setdefault(ENGINESDIR "${INSTALLPREFIX}/${LIBSUBDIR}/engines-3")
setdefault(MANDIR "${INSTALLPREFIX}/man")
