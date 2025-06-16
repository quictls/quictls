set(SOURCE
    openssl-asn1parse.pod
    openssl-cmds.pod
    openssl-engine.pod
    openssl-errstr.pod
    openssl-fipsinstall.pod
    openssl-info.pod
    openssl-sess_id.pod
    openssl-version.pod
    openssl-format-options.pod openssl-namedisplay-options.pod
    openssl-passphrase-options.pod openssl-verification-options.pod
    openssl.pod)

set(GENERATED
    ca ciphers cmp cms crl crl2pkcs7 dgst dhparam dsa dsaparam ec ecparam
    enc gendsa genpkey genrsa kdf list mac nseq ocsp passwd pkcs12
    pkcs7 pkcs8 pkey pkeyparam pkeyutl prime rand rehash req rsa rsautl
    s_client s_server s_time smime speed spkac storeutl ts verify x509)

foreach (F ${GENERATED})
    string(REPLACE XXX ${F} in ${CMAKE_SOURCE_DIR}/doc/man1/openssl-XXX.podin)
    string(REPLACE XXX ${F} out openssl-XXX.pod)
    list(APPEND SOURCE ${out})
    add_custom_command(COMMENT "Generating ${in} -> ${out}"
        OUTPUT ${out} DEPENDS ${in}
        COMMAND ${PERL} ${CMAKE_SOURCE_DIR}/doc/mkdoc.pl ${in} ${out}
        VERBATIM)
endforeach ()

makeman(1 SOURCE)
