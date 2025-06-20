#
project(QuicTLS)
cmake_minimum_required(VERSION 3.21)
enable_language(C ASM)

# Build time, or epoch for reproducible
if (NOT BUILD_DATE)
    string(TIMESTAMP BUILD_DATE UTC)
endif ()

# Version
set(OPENSSL_VERSION_MAJOR 3)
set(OPENSSL_VERSION_MINOR 4)
set(OPENSSL_VERSION_PATCH 0)
set(OPENSSL_VERSION_PRE_RELEASE "")
set(OPENSSL_VERSION_BUILD_METADATA "+quic")
if (NOT OPENSSL_VERSION_PRE_RELEASE)
    set(OPENSSL_PRE_MARKER "0x00")
else ()
    set(OPENSSL_PRE_MARKER "0x0f")
endif ()

# Architecture and byte-order
include(TargetArch.cmake)
target_architecture(ARCH)
if (NOT B_ENDIAN AND NOT L_ENDIAN)
    if (${CMAKE_C_BYTE_ORDER} STREQUAL "BIG_ENDIAN")
        set(B_ENDIAN 1)
    elseif (${CMAKE_C_BYTE_ORDER} STREQUAL "LITTLE_ENDIAN")
        set(L_ENDIAN 1)
    else ()
        message(FATAL_ERROR "Can't determine byte order")
    endif ()
endif ()

# Load built-in configs.
file(GLOB cmakefiles Configs/*.cmake)
foreach (cfg ${cmakefiles})
    include(${cfg})
endforeach ()
include(Configs/OpenSSLDefaults.cmake)
OpenSSLDefaults()

# If given a target, try to configure or use env var.
if (TARGET)
    if (NOT COMMAND ${TARGET})
        message(FATAL_ERROR "No ${TARGET} configuration found")
    endif ()
    cmake_language(CALL ${TARGET})
elseif (DEFINED ENV{LOCAL_BUILD_SETTINGS})
    include($ENV{LOCAL_BUILD_SETTINGS} RESULT_VARIABLE LOCAL_INC)
    message("Read ${LOCAL_INC}")
else ()
    if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(TARGET "linux_generic64")
	cmake_language(CALL ${TARGET})
    else ()
       message(FATAL_ERROR "No -DTARGET=... defined")
    endif()
endif ()

# XXX REMOVE THESE ONCE SUPPORTED
set(OPENSSL_NO_LEGACY 1)
set(OPENSSL_NO_FUZZ 1) #mystery
# Threads
if (NOT OPENSSL_THREADS_NONE)
    set(OPENSSL_THREADS 1)
    if (NOT OPENSSL_THREADS_POSIX AND NOT OPENSSL_THREADS_WINNT)
        if (UNIX)
            set(OPENSSL_THREADS_POSIX 1)
        elseif (WIN32)
            set(OPENSSL_THREADS_WINNT 1)
        endif ()
    endif ()
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads REQUIRED)
endif ()

include(CheckSettings.cmake)

# Locate some useful things.
include(FindPerl)
if (NOT PERL_FOUND)
    message(FATAL_ERROR "Cannot find perl")
endif ()
set(PERL ${PERL_EXECUTABLE})
if (NOT OPENSSL_NO_DOC)
    find_program(POD2MAN "pod2man")
    if (${POD2MAN} STREQUAL "POD2MAN-NOTFOUND")
        message(FATAL_ERROR "Can't found pod2man, set OPENSSL_NO_DOC")
    endif ()
endif ()
find_program(CCACHE_FOUND ccache)
if (CCACHE_FOUND)
    set(CMAKE_C_COMPILER_LAUNCHER ccache)
endif ()

# What sub-directories we care about.
set(SUBDIRS crypto ssl)
if (NOT OPENSSL_NO_APPS)
    list(APPEND SUBDIRS apps)
endif ()
list(APPEND SUBDIRS providers)
if (NOT OPENSSL_NO_DOC)
    list(APPEND SUBDIRS doc)
endif ()
if (NOT OPENSSL_NO_TESTS)
    execute_process(COMMAND ${PERL} -MTAP::Parser -e ""
        ERROR_QUIET RESULT_VARIABLE status)
    if (NOT ${status} EQUAL 0)
        message(FATAL_ERROR "Tests require perl TAP::Parser module")
    endif ()
    list(APPEND SUBDIRS test)
    if (NOT OPENSSL_NO_BUILDTEST_CXX)
        enable_language(CXX)
    endif ()
endif ()
if (NOT OPENSSL_NO_FUZZ)
    list(APPEND SUBDIRS fuzz)
endif ()
if (NOT OPENSSL_NO_DEPRECATED_3_0)
    list(APPEND SUBDIRS engines)
endif ()
list(APPEND SUBDIRS exporters)
add_custom_target(world DEPEND ${SUBDIRS})

# Generate configuration header files.
set(MADEHEADERS)
foreach (f openssl/configuration.h openssl/opensslv.h internal/paths.h)
    set(in include/${f}.in)
    set(out include/${f})
    configure_file(${in} ${out})
    list(APPEND MADEHEADERS ${out})
endforeach ()
configure_file("test/testvars.pm.in" "test/testvars.pm")
configure_file("test/run_tests.in" "test/run_tests")

# Generate some header files.
set(GENHEADERS
    openssl/asn1.h openssl/asn1t.h openssl/bio.h openssl/cmp.h
    openssl/cms.h openssl/conf.h openssl/crmf.h openssl/crypto.h
    openssl/ct.h openssl/err.h openssl/ess.h openssl/lhash.h
    openssl/ocsp.h openssl/pkcs12.h openssl/pkcs7.h openssl/safestack.h
    openssl/ssl.h openssl/ui.h openssl/x509.h openssl/x509v3.h
    openssl/x509_vfy.h )
set(mkhdr ${CMAKE_SOURCE_DIR}/include/mkhdr.pl)
foreach (f ${GENHEADERS})
    set(in ${CMAKE_SOURCE_DIR}/include/${f}.in)
    set(out include/${f})
    list(APPEND MADEHEADERS ${CMAKE_BINARY_DIR}/${out})
    add_custom_command(COMMENT "Generating ${out}"
        OUTPUT ${out} DEPENDS ${in} ${mkhdr}
        COMMAND ${PERL} ${mkhdr} ${in} ${out}
        VERBATIM)
endforeach ()
add_custom_target(headers COMMENT "Generated headers"
    DEPENDS ${MADEHEADERS})
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/include/apps)

# System and local header files.
include(CheckIncludeFiles)
CHECK_INCLUDE_FILES(fcntl.h HAVE_FCNTL_HEADER)
CHECK_INCLUDE_FILES(dlfcn.h HAVE_DLFCN_HEADER)
CHECK_INCLUDE_FILES(locale.h HAVE_LOCALE_HEADER)
CHECK_INCLUDE_FILES(sys/syscall.h HAVE_SYS_SYSCALL_HEADER)
CHECK_INCLUDE_FILES(linux/mman.h HAVE_LINUX_MMAN_HEADER)
CHECK_INCLUDE_FILES(CommonCrypto/CommonCryptoError.h HAVE_APPLE_HEADERS)
include_directories(include ${CMAKE_BINARY_DIR}/include)

if (NOT OPENSSL_NO_SHARED)
    add_library(crypto SHARED)
    add_library(ssl SHARED)
    add_library(crypto-static STATIC $<TARGET_OBJECTS:crypto>)
    add_library(ssl-static STATIC $<TARGET_OBJECTS:ssl>)
    set_target_properties(crypto-static PROPERTIES OUTPUT_NAME crypto)
    set_target_properties(ssl-static PROPERTIES OUTPUT_NAME ssl)
else ()
    add_library(crypto STATIC)
    add_library(ssl STATIC)
endif ()
install(TARGETS crypto
    RUNTIME DESTINATION bin ARCHIVE DESTINATION ${LIBSUBDIR}/quictls
    LIBRARY DESTINATION ${LIBSUBDIR})
install(TARGETS ssl
    RUNTIME DESTINATION bin ARCHIVE DESTINATION ${LIBSUBDIR}/quictls
    LIBRARY DESTINATION ${LIBSUBDIR})
target_include_directories(crypto PUBLIC ${CMAKE_BINARY_DIR}/include)
add_dependencies(crypto headers)
target_link_libraries(crypto PUBLIC common defprov)
target_link_libraries(crypto-static PUBLIC common defprov)

if (NOT OPENSSL_THREADS_NONE)
    target_link_libraries(crypto PUBLIC Threads::Threads)
endif ()
target_include_directories(ssl PUBLIC ${CMAKE_BINARY_DIR}/include)
add_dependencies(ssl headers)

foreach (SD ${SUBDIRS})
    add_subdirectory(${SD})
endforeach ()

target_link_libraries(ssl PUBLIC crypto)
target_link_libraries(ssl-static PUBLIC crypto-static)

# in the toolchain file(?)
# SET(ASM_OPTIONS "-x assembler-with-cpp")
# SET(CMAKE_ASM_FLAGS "${CFLAGS} ${ASM_OPTIONS}" )

#/* XXX NEED TO SET THESE */ include/crypto/dso_conf.h
## define DSO_DLFCN

add_custom_target(test
    COMMAND SRCTOP=${CMAKE_SOURCE_DIR} BLDTOP=${CMAKE_BINARY_DIR} perl ${CMAKE_SOURCE_DIR}/test/run_tests.pl
	VERBATIM
	USES_TERMINAL
	)
set_property(TARGET test PROPERTY EXCLUDE_FROM_ALL 1)
add_dependencies(test build_tests)

include(hide_symbols.cmake)
export_symbol(ssl libssl.sym)
export_symbol(crypto libcrypto.sym)
