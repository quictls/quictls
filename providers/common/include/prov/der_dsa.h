/*
 * Copyright 2020-2021 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include "internal/der.h"

/* Well known OIDs precompiled */

/*
 * id-dsa OBJECT IDENTIFIER ::= {
 *      iso(1) member-body(2) us(840) x9-57(10040) x9algorithm(4) 1 }
 */
#define DER_OID_V_id_dsa DER_P_OBJECT, 7, 0x2A, 0x86, 0x48, 0xCE, 0x38, 0x04, 0x01
#define DER_OID_SZ_id_dsa 9
extern const unsigned char ossl_der_oid_id_dsa[DER_OID_SZ_id_dsa];

/*
 * id-dsa-with-sha1 OBJECT IDENTIFIER ::=  {
 *      iso(1) member-body(2) us(840) x9-57 (10040) x9algorithm(4) 3 }
 */
#define DER_OID_V_id_dsa_with_sha1 DER_P_OBJECT, 7, 0x2A, 0x86, 0x48, 0xCE, 0x38, 0x04, 0x03
#define DER_OID_SZ_id_dsa_with_sha1 9
extern const unsigned char ossl_der_oid_id_dsa_with_sha1[DER_OID_SZ_id_dsa_with_sha1];

/*
 * id-dsa-with-sha224 OBJECT IDENTIFIER ::= { sigAlgs 1 }
 */
#define DER_OID_V_id_dsa_with_sha224 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x01
#define DER_OID_SZ_id_dsa_with_sha224 11
extern const unsigned char ossl_der_oid_id_dsa_with_sha224[DER_OID_SZ_id_dsa_with_sha224];

/*
 * id-dsa-with-sha256 OBJECT IDENTIFIER ::= { sigAlgs 2 }
 */
#define DER_OID_V_id_dsa_with_sha256 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x02
#define DER_OID_SZ_id_dsa_with_sha256 11
extern const unsigned char ossl_der_oid_id_dsa_with_sha256[DER_OID_SZ_id_dsa_with_sha256];

/*
 * id-dsa-with-sha384 OBJECT IDENTIFIER ::= { sigAlgs 3 }
 */
#define DER_OID_V_id_dsa_with_sha384 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x03
#define DER_OID_SZ_id_dsa_with_sha384 11
extern const unsigned char ossl_der_oid_id_dsa_with_sha384[DER_OID_SZ_id_dsa_with_sha384];

/*
 * id-dsa-with-sha512 OBJECT IDENTIFIER ::= { sigAlgs 4 }
 */
#define DER_OID_V_id_dsa_with_sha512 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x04
#define DER_OID_SZ_id_dsa_with_sha512 11
extern const unsigned char ossl_der_oid_id_dsa_with_sha512[DER_OID_SZ_id_dsa_with_sha512];

/*
 * id-dsa-with-sha3-224 OBJECT IDENTIFIER ::= { sigAlgs 5 }
 */
#define DER_OID_V_id_dsa_with_sha3_224 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x05
#define DER_OID_SZ_id_dsa_with_sha3_224 11
extern const unsigned char ossl_der_oid_id_dsa_with_sha3_224[DER_OID_SZ_id_dsa_with_sha3_224];

/*
 * id-dsa-with-sha3-256 OBJECT IDENTIFIER ::= { sigAlgs 6 }
 */
#define DER_OID_V_id_dsa_with_sha3_256 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x06
#define DER_OID_SZ_id_dsa_with_sha3_256 11
extern const unsigned char ossl_der_oid_id_dsa_with_sha3_256[DER_OID_SZ_id_dsa_with_sha3_256];

/*
 * id-dsa-with-sha3-384 OBJECT IDENTIFIER ::= { sigAlgs 7 }
 */
#define DER_OID_V_id_dsa_with_sha3_384 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x07
#define DER_OID_SZ_id_dsa_with_sha3_384 11
extern const unsigned char ossl_der_oid_id_dsa_with_sha3_384[DER_OID_SZ_id_dsa_with_sha3_384];

/*
 * id-dsa-with-sha3-512 OBJECT IDENTIFIER ::= { sigAlgs 8 }
 */
#define DER_OID_V_id_dsa_with_sha3_512 DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x08
#define DER_OID_SZ_id_dsa_with_sha3_512 11
extern const unsigned char ossl_der_oid_id_dsa_with_sha3_512[DER_OID_SZ_id_dsa_with_sha3_512];


/* Subject Public Key Info */
int ossl_DER_w_algorithmIdentifier_DSA(WPACKET *pkt, int tag, DSA *dsa);
/* Signature */
int ossl_DER_w_algorithmIdentifier_DSA_with_MD(WPACKET *pkt, int tag,
                                               DSA *dsa, int mdnid);