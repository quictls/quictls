/*
 * Copyright 2020-2021 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <providers/der_digests.h>

/* Well known OIDs precompiled */

/*
 * sigAlgs OBJECT IDENTIFIER ::= { nistAlgorithms 3 }
 */
const unsigned char ossl_der_oid_sigAlgs[DER_OID_SZ_sigAlgs] = {
    DER_OID_V_sigAlgs
};

/*
 * id-sha1  OBJECT IDENTIFIER  ::=  { iso(1)
 *                      identified-organization(3) oiw(14)
 *                      secsig(3) algorithms(2) 26 }
 */
const unsigned char ossl_der_oid_id_sha1[DER_OID_SZ_id_sha1] = {
    DER_OID_V_id_sha1
};

/*
 * id-md2  OBJECT IDENTIFIER ::= {
 *   iso(1) member-body(2) us(840) rsadsi(113549) digestAlgorithm(2) 2 }
 */
const unsigned char ossl_der_oid_id_md2[DER_OID_SZ_id_md2] = {
    DER_OID_V_id_md2
};

/*
 * id-md5  OBJECT IDENTIFIER ::= {
 *   iso(1) member-body(2) us(840) rsadsi(113549) digestAlgorithm(2) 5 }
 */
const unsigned char ossl_der_oid_id_md5[DER_OID_SZ_id_md5] = {
    DER_OID_V_id_md5
};

/*
 * id-sha256 OBJECT IDENTIFIER ::= { hashAlgs 1 }
 */
const unsigned char ossl_der_oid_id_sha256[DER_OID_SZ_id_sha256] = {
    DER_OID_V_id_sha256
};

/*
 * id-sha384 OBJECT IDENTIFIER ::= { hashAlgs 2 }
 */
const unsigned char ossl_der_oid_id_sha384[DER_OID_SZ_id_sha384] = {
    DER_OID_V_id_sha384
};

/*
 * id-sha512 OBJECT IDENTIFIER ::= { hashAlgs 3 }
 */
const unsigned char ossl_der_oid_id_sha512[DER_OID_SZ_id_sha512] = {
    DER_OID_V_id_sha512
};

/*
 * id-sha224 OBJECT IDENTIFIER ::= { hashAlgs 4 }
 */
const unsigned char ossl_der_oid_id_sha224[DER_OID_SZ_id_sha224] = {
    DER_OID_V_id_sha224
};

/*
 * id-sha512-224 OBJECT IDENTIFIER ::= { hashAlgs 5 }
 */
const unsigned char ossl_der_oid_id_sha512_224[DER_OID_SZ_id_sha512_224] = {
    DER_OID_V_id_sha512_224
};

/*
 * id-sha512-256 OBJECT IDENTIFIER ::= { hashAlgs 6 }
 */
const unsigned char ossl_der_oid_id_sha512_256[DER_OID_SZ_id_sha512_256] = {
    DER_OID_V_id_sha512_256
};

/*
 * id-sha3-224 OBJECT IDENTIFIER ::= { hashAlgs 7 }
 */
const unsigned char ossl_der_oid_id_sha3_224[DER_OID_SZ_id_sha3_224] = {
    DER_OID_V_id_sha3_224
};

/*
 * id-sha3-256 OBJECT IDENTIFIER ::= { hashAlgs 8 }
 */
const unsigned char ossl_der_oid_id_sha3_256[DER_OID_SZ_id_sha3_256] = {
    DER_OID_V_id_sha3_256
};

/*
 * id-sha3-384 OBJECT IDENTIFIER ::= { hashAlgs 9 }
 */
const unsigned char ossl_der_oid_id_sha3_384[DER_OID_SZ_id_sha3_384] = {
    DER_OID_V_id_sha3_384
};

/*
 * id-sha3-512 OBJECT IDENTIFIER ::= { hashAlgs 10 }
 */
const unsigned char ossl_der_oid_id_sha3_512[DER_OID_SZ_id_sha3_512] = {
    DER_OID_V_id_sha3_512
};

/*
 * id-shake128 OBJECT IDENTIFIER ::= { hashAlgs 11 }
 */
const unsigned char ossl_der_oid_id_shake128[DER_OID_SZ_id_shake128] = {
    DER_OID_V_id_shake128
};

/*
 * id-shake256 OBJECT IDENTIFIER ::= { hashAlgs 12 }
 */
const unsigned char ossl_der_oid_id_shake256[DER_OID_SZ_id_shake256] = {
    DER_OID_V_id_shake256
};

/*
 * id-shake128-len OBJECT IDENTIFIER ::= { hashAlgs 17 }
 */
const unsigned char ossl_der_oid_id_shake128_len[DER_OID_SZ_id_shake128_len] = {
    DER_OID_V_id_shake128_len
};

/*
 * id-shake256-len OBJECT IDENTIFIER ::= { hashAlgs 18 }
 */
const unsigned char ossl_der_oid_id_shake256_len[DER_OID_SZ_id_shake256_len] = {
    DER_OID_V_id_shake256_len
};

/*
 * id-KMACWithSHAKE128 OBJECT IDENTIFIER ::={hashAlgs 19}
 */
const unsigned char ossl_der_oid_id_KMACWithSHAKE128[DER_OID_SZ_id_KMACWithSHAKE128] = {
    DER_OID_V_id_KMACWithSHAKE128
};

/*
 * id-KMACWithSHAKE256 OBJECT IDENTIFIER ::={ hashAlgs 20}
 */
const unsigned char ossl_der_oid_id_KMACWithSHAKE256[DER_OID_SZ_id_KMACWithSHAKE256] = {
    DER_OID_V_id_KMACWithSHAKE256
};

