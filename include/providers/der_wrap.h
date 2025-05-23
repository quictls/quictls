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
 * id-alg-CMS3DESwrap OBJECT IDENTIFIER ::= {
 *     iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-9(9) smime(16) alg(3) 6
 * }
 */
#define DER_OID_V_id_alg_CMS3DESwrap DER_P_OBJECT, 11, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x09, 0x10, 0x03, 0x06
#define DER_OID_SZ_id_alg_CMS3DESwrap 13
extern const unsigned char ossl_der_oid_id_alg_CMS3DESwrap[DER_OID_SZ_id_alg_CMS3DESwrap];

/*
 * id-aes128-wrap OBJECT IDENTIFIER ::= { aes 5 }
 */
#define DER_OID_V_id_aes128_wrap DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x01, 0x05
#define DER_OID_SZ_id_aes128_wrap 11
extern const unsigned char ossl_der_oid_id_aes128_wrap[DER_OID_SZ_id_aes128_wrap];

/*
 * id-aes192-wrap OBJECT IDENTIFIER ::= { aes 25 }
 */
#define DER_OID_V_id_aes192_wrap DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x01, 0x19
#define DER_OID_SZ_id_aes192_wrap 11
extern const unsigned char ossl_der_oid_id_aes192_wrap[DER_OID_SZ_id_aes192_wrap];

/*
 * id-aes256-wrap OBJECT IDENTIFIER ::= { aes 45 }
 */
#define DER_OID_V_id_aes256_wrap DER_P_OBJECT, 9, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x01, 0x2D
#define DER_OID_SZ_id_aes256_wrap 11
extern const unsigned char ossl_der_oid_id_aes256_wrap[DER_OID_SZ_id_aes256_wrap];

