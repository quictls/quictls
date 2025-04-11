set(OPENSSL_VERSION
    "${OPENSSL_VERSION_MAJOR}."
    "${OPENSSL_VERSION_MINOR}."
    "${OPENSSL_VERSION_PATCH}")
set(OPENSSL_VERSION_NUM
    "${OPENSSL_VERSION_MAJOR}${OPENSSL_VERSION_MINOR}${OPENSSL_VERSION_PATCH}")
set(OPENSSL_FULL_VERSION_STR
    "${OPENSSL_VERSION_PRE_RELEASE}"
    "${OPENSSL_VERSION}"
    "${OPENSSL_VERSION_BUILD_METADATA}")
set(OPENSSL_EXTRA_LIBS "-l Other libraries to link with")
set(OPENSSL_INCLUDE_DIR ".../include")
set(OPENSSL_LIB_DIR ".../lib")

set(FILES OpenSSLConfigVersion.cmake libcrypto.pc libssl.pc openssl.pc)
foreach (F ${FILES})
    configure_file("${F}.in" "${F}")
endforeach ()

install(FILES libcrypto.pc libssl.pc openssl.pc
    DESTINATION lib/pkgconfig)
install(FILES OpenSSLConfigVersion.cmake
    DESTINATION lib/cmake/OpenSSL)
