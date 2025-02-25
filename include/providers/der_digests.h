/*
 * Copyright 2020-2021 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <internal/der.h>

/* Well known OIDs precompiled */

/*
 * sigAlgs OBJECT IDENTIFIER ::= { nistAlgorithms 3 }
 */
#define DER_OID_V_sigAlgs DER_P_OBJECT, 8, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03
#define DER_OID_SZ_sigAlgs 10
extern const unsigned char ossl_der_oid_sigAlgs[DER_OID_SZ_sigAlgs];

/*
 * id-sha1  OBJECT IDENTIFIER  ::=  { iso(1)
 *                      identified-organization(3) oiw(14)
 *                      secsig(3) algorithms(2) 26 }
 */
#define DER_OID_V_id_sha1 DER_P_OBJECT, 5, 0x2B, 0x0E, 0x03, 0x02, 0x1A
#define DER_OID_SZ_id_sha1 7
extern const unsigned char ossl_der_oid_id_sha1[DER_OID_SZ_id_sha1];

/*
 * id-md2  OBJECT IDENTIFIER ::= {
 *   iso(1) member-body(2) us(840) rsadsi(113549) digestAlgorithm(2) 2 }
 */
#define DER_OID_V_id_md2 DER_P_OBJECT, 8, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x02, 0x02
#define DER_OID_SZ_id_md2 10
extern const unsigned char ossl_der_oid_id_md2[DER_OID_SZ_id_md2];

/*
 * id-md5  OBJECT IDENTIFIER ::= {
 *   iso(1) member-body(2) us(840) rsadsi(113549) digestAlgorithm(2) 5 }
 */
#define DER_OID_V_id_md5 DER_P_OBJECT, 8, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x02, 0x05
#define DER_OID_SZ_id_md5 10
extern const unsigned char ossl_der_oid_id_md5[DER_OID_SZ_id_md5];

/*
 * id-sha256 OBJECT IDENTIFIER ::= { hashAlgs 1 }
 */
#define DER_OID_V_id_sha256 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01
#define DER_OID_SZ_id_sha256 11
extern const unsigned char ossl_der_oid_id_sha256[DER_OID_SZ_id_sha256];

/*
 * id-sha384 OBJECT IDENTIFIER ::= { hashAlgs 2 }
 */
#define DER_OID_V_id_sha384 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02
#define DER_OID_SZ_id_sha384 11
extern const unsigned char ossl_der_oid_id_sha384[DER_OID_SZ_id_sha384];

/*
 * id-sha512 OBJECT IDENTIFIER ::= { hashAlgs 3 }
 */
#define DER_OID_V_id_sha512 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03
#define DER_OID_SZ_id_sha512 11
extern const unsigned char ossl_der_oid_id_sha512[DER_OID_SZ_id_sha512];

/*
 * id-sha224 OBJECT IDENTIFIER ::= { hashAlgs 4 }
 */
#define DER_OID_V_id_sha224 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04
#define DER_OID_SZ_id_sha224 11
extern const unsigned char ossl_der_oid_id_sha224[DER_OID_SZ_id_sha224];

/*
 * id-sha512-224 OBJECT IDENTIFIER ::= { hashAlgs 5 }
 */
#define DER_OID_V_id_sha512_224 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x05
#define DER_OID_SZ_id_sha512_224 11
extern const unsigned char ossl_der_oid_id_sha512_224[DER_OID_SZ_id_sha512_224];

/*
 * id-sha512-256 OBJECT IDENTIFIER ::= { hashAlgs 6 }
 */
#define DER_OID_V_id_sha512_256 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x06
#define DER_OID_SZ_id_sha512_256 11
extern const unsigned char ossl_der_oid_id_sha512_256[DER_OID_SZ_id_sha512_256];

/*
 * id-sha3-224 OBJECT IDENTIFIER ::= { hashAlgs 7 }
 */
#define DER_OID_V_id_sha3_224 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x07
#define DER_OID_SZ_id_sha3_224 11
extern const unsigned char ossl_der_oid_id_sha3_224[DER_OID_SZ_id_sha3_224];

/*
 * id-sha3-256 OBJECT IDENTIFIER ::= { hashAlgs 8 }
 */
#define DER_OID_V_id_sha3_256 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x08
#define DER_OID_SZ_id_sha3_256 11
extern const unsigned char ossl_der_oid_id_sha3_256[DER_OID_SZ_id_sha3_256];

/*
 * id-sha3-384 OBJECT IDENTIFIER ::= { hashAlgs 9 }
 */
#define DER_OID_V_id_sha3_384 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x09
#define DER_OID_SZ_id_sha3_384 11
extern const unsigned char ossl_der_oid_id_sha3_384[DER_OID_SZ_id_sha3_384];

/*
 * id-sha3-512 OBJECT IDENTIFIER ::= { hashAlgs 10 }
 */
#define DER_OID_V_id_sha3_512 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x0A
#define DER_OID_SZ_id_sha3_512 11
extern const unsigned char ossl_der_oid_id_sha3_512[DER_OID_SZ_id_sha3_512];

/*
 * id-shake128 OBJECT IDENTIFIER ::= { hashAlgs 11 }
 */
#define DER_OID_V_id_shake128 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x0B
#define DER_OID_SZ_id_shake128 11
extern const unsigned char ossl_der_oid_id_shake128[DER_OID_SZ_id_shake128];

/*
 * id-shake256 OBJECT IDENTIFIER ::= { hashAlgs 12 }
 */
#define DER_OID_V_id_shake256 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x0C
#define DER_OID_SZ_id_shake256 11
extern const unsigned char ossl_der_oid_id_shake256[DER_OID_SZ_id_shake256];

/*
 * id-shake128-len OBJECT IDENTIFIER ::= { hashAlgs 17 }
 */
#define DER_OID_V_id_shake128_len DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x11
#define DER_OID_SZ_id_shake128_len 11
extern const unsigned char ossl_der_oid_id_shake128_len[DER_OID_SZ_id_shake128_len];

/*
 * id-shake256-len OBJECT IDENTIFIER ::= { hashAlgs 18 }
 */
#define DER_OID_V_id_shake256_len DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x12
#define DER_OID_SZ_id_shake256_len 11
extern const unsigned char ossl_der_oid_id_shake256_len[DER_OID_SZ_id_shake256_len];

/*
 * id-KMACWithSHAKE128 OBJECT IDENTIFIER ::={hashAlgs 19}
 */
#define DER_OID_V_id_KMACWithSHAKE128 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x13
#define DER_OID_SZ_id_KMACWithSHAKE128 11
extern const unsigned char ossl_der_oid_id_KMACWithSHAKE128[DER_OID_SZ_id_KMACWithSHAKE128];

/*
 * id-KMACWithSHAKE256 OBJECT IDENTIFIER ::={ hashAlgs 20}
 */
#define DER_OID_V_id_KMACWithSHAKE256 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x14
#define DER_OID_SZ_id_KMACWithSHAKE256 11
extern const unsigned char ossl_der_oid_id_KMACWithSHAKE256[DER_OID_SZ_id_KMACWithSHAKE256];

