# cmake file for the openssl app. Only loaded if building it.

# Get the list of source files.
set(SOURCE)
# This must be the first source file.
if (${OPENSSL_DO_UPLINK})
    list(APPEND SOURCE ../ms/applink.c)
endif ()
list(APPEND SOURCE openssl.c
    asn1parse.c ca.c ciphers.c crl.c crl2pkcs7.c dgst.c enc.c
    errstr.c fipsinstall.c genpkey.c info.c kdf.c list.c mac.c
    passwd.c pkcs12.c pkcs7.c pkcs8.c pkey.c pkeyparam.c pkeyutl.c
    prime.c rand.c rehash.c req.c
    sess_id.c smime.c speed.c spkac.c storeutl.c verify.c version.c
    x509.c
    )
if (NOT OPENSSL_NO_CMP)
    list(APPEND SOURCE cmp.c lib/cmp_mock_srv.c)
endif ()
if (NOT OPENSSL_NO_CMS)
    list(APPEND SOURCE cms.c)
endif ()
if (NOT OPENSSL_NO_DSA)
    list(APPEND SOURCE dsa.c dsaparam.c gendsa.c)
endif ()
if (NOT OPENSSL_NO_DH)
    list(APPEND SOURCE dhparam.c)
endif ()
if (NOT OPENSSL_NO_EC)
    list(APPEND SOURCE ec.c ecparam.c)
endif ()
if (NOT OPENSSL_NO_ENGINE)
    list(APPEND SOURCE engine.c)
endif ()
if (NOT OPENSSL_NO_OCSP)
    list(APPEND SOURCE ocsp.c)
endif ()
if (NOT OPENSSL_NO_RSA)
    list(APPEND SOURCE rsa.c genrsa.c)
    if (NOT OPENSSL_NO_DEPRECATED_3_0)
        list(APPEND SOURCE rsautl.c)
      endif ()
endif ()
if (NOT OPENSSL_NO_SOCK)
    list(APPEND SOURCE s_client.c s_server.c s_time.c)
endif ()
if (NOT OPENSSL_NO_TS)
    list(APPEND SOURCE ts.c)
endif ()
if (WIN32)
    set(rc openssl.rc)
    add_custom_command(COMMENT "Generating ${rc}"
        OUTPUT "${rc}" DEPENDS ../util/mkrc.pl
        COMMAND ${PERL} ../util/mkrc.pl openssl >${rc}
        VERBATIM)
    list(APPEND SOURCE ${rc})
endif ()

set(mkprog ${CMAKE_SOURCE_DIR}/apps/mkprogs.pl)
set(phdr ../include/apps/progs.h)
set(psrc progs.c)
add_custom_command(COMMENT "Generating ${phdr}"
    OUTPUT ${phdr} DEPENDS ${SOURCE} ${mkprog}
    COMMAND ${PERL} ${mkprog} -H ${phdr} ${CMAKE_CURRENT_SOURCE_DIR} ${SOURCE}
    VERBATIM)
add_custom_command(COMMENT "Generating ${psrc}"
    OUTPUT ${psrc} DEPENDS ${SOURCE} ${mkprog}
    COMMAND ${PERL} ${mkprog} -C ${psrc} ${CMAKE_CURRENT_SOURCE_DIR} ${SOURCE}
    VERBATIM)
list(APPEND SOURCE ${psrc})
add_custom_target(progs COMMENT "Generated progs.[ch]"
    DEPENDS ${phdr} ${psrc})

add_subdirectory(lib)

add_executable(openssl)
install(TARGETS openssl DESTINATION bin)
target_include_directories(openssl PUBLIC ${CMAKE_BINARY_DIR}/include)
add_dependencies(openssl headers progs)
target_sources(openssl PRIVATE ${SOURCE})
target_link_libraries(openssl apps ssl crypto)
