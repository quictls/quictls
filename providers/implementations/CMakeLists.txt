set(SUBDIRS
    digests ciphers rands macs kdfs exchange keymgmt signature asymciphers
    encode_decode storemgmt kem
    )

foreach (SD ${SUBDIRS})
    add_subdirectory(${SD})
endforeach ()
