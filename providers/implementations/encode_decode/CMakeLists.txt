target_sources(defprov PRIVATE 
    endecoder_common.c decode_der2key.c decode_epki2pki.c decode_pem2der.c
    decode_msblob2key.c decode_pvk2key.c decode_spki2typespki.c
    encode_key2any.c encode_key2text.c encode_key2ms.c
    )

if (NOT OPENSSL_NO_EC)
    target_sources(defprov PRIVATE encode_key2blob.c)
endif ()

#DEPEND[encode_key2any.o]=../../../include/providers/der_rsa.h
