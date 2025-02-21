set(SOURCE
    openssl-format-options.pod openssl-namedisplay-options.pod
    openssl-passphrase-options.pod openssl-verification-options.pod
    openssl.pod)

set(GENERATED
    asn1parse ca ciphers cmds cmp cms crl crl2pkcs7 dgst dhparam dsa
    dsaparam ec ecparam enc engine errstr fipsinstall gendsa genpkey
    genrsa info kdf list mac nseq ocsp passwd pkcs12 pkcs7 pkcs8 pkey
    pkeyparam pkeyutl prime rand rehash req rsa rsautl s_client s_server
    s_time sess_id smime speed spkac storeutl ts verify version x509)
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
