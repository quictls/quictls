set(SOURCE
    EVP_ASYM_CIPHER-RSA.pod EVP_ASYM_CIPHER-SM2.pod EVP_CIPHER-AES.pod
    EVP_CIPHER-ARIA.pod EVP_CIPHER-BLOWFISH.pod EVP_CIPHER-CAMELLIA.pod
    EVP_CIPHER-CAST.pod EVP_CIPHER-CHACHA.pod EVP_CIPHER-DES.pod
    EVP_CIPHER-IDEA.pod EVP_CIPHER-NULL.pod EVP_CIPHER-RC2.pod
    EVP_CIPHER-RC4.pod EVP_CIPHER-RC5.pod EVP_CIPHER-SEED.pod
    EVP_CIPHER-SM4.pod EVP_KDF-ARGON2.pod EVP_KDF-HKDF.pod
    EVP_KDF-HMAC-DRBG.pod EVP_KDF-KB.pod EVP_KDF-KRB5KDF.pod
    EVP_KDF-PBKDF1.pod EVP_KDF-PBKDF2.pod EVP_KDF-PKCS12KDF.pod
    EVP_KDF-PVKKDF.pod EVP_KDF-SCRYPT.pod EVP_KDF-SS.pod EVP_KDF-SSHKDF.pod
    EVP_KDF-TLS13_KDF.pod EVP_KDF-TLS1_PRF.pod EVP_KDF-X942-ASN1.pod
    EVP_KDF-X942-CONCAT.pod EVP_KDF-X963.pod EVP_KEM-EC.pod EVP_KEM-RSA.pod
    EVP_KEM-X25519.pod EVP_KEYEXCH-DH.pod EVP_KEYEXCH-ECDH.pod
    EVP_KEYEXCH-X25519.pod EVP_MAC-BLAKE2.pod EVP_MAC-CMAC.pod
    EVP_MAC-GMAC.pod EVP_MAC-HMAC.pod EVP_MAC-KMAC.pod EVP_MAC-Poly1305.pod
    EVP_MAC-Siphash.pod EVP_MD-BLAKE2.pod EVP_MD-KECCAK.pod EVP_MD-MD2.pod
    EVP_MD-MD4.pod EVP_MD-MD5-SHA1.pod EVP_MD-MD5.pod EVP_MD-MDC2.pod
    EVP_MD-NULL.pod EVP_MD-RIPEMD160.pod EVP_MD-SHA1.pod EVP_MD-SHA2.pod
    EVP_MD-SHA3.pod EVP_MD-SHAKE.pod EVP_MD-SM3.pod EVP_MD-WHIRLPOOL.pod
    EVP_MD-common.pod EVP_PKEY-DH.pod EVP_PKEY-DSA.pod EVP_PKEY-EC.pod
    EVP_PKEY-FFC.pod EVP_PKEY-HMAC.pod EVP_PKEY-RSA.pod EVP_PKEY-SM2.pod
    EVP_PKEY-X25519.pod EVP_RAND-CTR-DRBG.pod EVP_RAND-HASH-DRBG.pod
    EVP_RAND-HMAC-DRBG.pod EVP_RAND-SEED-SRC.pod EVP_RAND-TEST-RAND.pod
    EVP_RAND.pod EVP_SIGNATURE-DSA.pod EVP_SIGNATURE-ECDSA.pod
    EVP_SIGNATURE-ED25519.pod EVP_SIGNATURE-HMAC.pod EVP_SIGNATURE-RSA.pod
    OSSL_PROVIDER-FIPS.pod OSSL_PROVIDER-base.pod OSSL_PROVIDER-default.pod
    OSSL_PROVIDER-legacy.pod OSSL_PROVIDER-null.pod RAND.pod RSA-PSS.pod
    X25519.pod bio.pod crypto.pod ct.pod des_modes.pod evp.pod
    life_cycle-cipher.pod life_cycle-digest.pod life_cycle-kdf.pod
    life_cycle-mac.pod life_cycle-pkey.pod life_cycle-rand.pod
    migration-guide.pod openssl-core.h.pod openssl-core_dispatch.h.pod
    openssl-core_names.h.pod openssl-env.pod openssl-glossary.pod
    openssl-threads.pod openssl_user_macros.pod ossl_store-file.pod
    ossl_store.pod passphrase-encoding.pod property.pod
    provider-asym_cipher.pod provider-base.pod provider-cipher.pod
    provider-decoder.pod provider-digest.pod provider-encoder.pod
    provider-kdf.pod provider-kem.pod provider-keyexch.pod
    provider-keymgmt.pod provider-mac.pod provider-object.pod
    provider-rand.pod provider-signature.pod provider-storemgmt.pod
    provider.pod proxy-certificates.pod ssl.pod x509.pod
    )

makeman(7 SOURCE)
