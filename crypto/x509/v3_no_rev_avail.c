/*
 * Copyright 2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <stdio.h>
#include <internal/cryptlib.h>
#include <openssl/asn1.h>
#include <openssl/asn1t.h>
#include <openssl/x509v3.h>
#include "ext_dat.h"

static int i2r_NO_REV_AVAIL(X509V3_EXT_METHOD *method,
                            void *su, BIO *out,
                            int indent)
{
    return 1;
}

static void *r2i_NO_REV_AVAIL(X509V3_EXT_METHOD *method,
                            X509V3_CTX *ctx, const char *value)
{
    return ASN1_NULL_new();
}

static char *i2s_NO_REV_AVAIL(const X509V3_EXT_METHOD *method, void *val)
{
    return OPENSSL_strdup("NULL");
}

static void *s2i_NO_REV_AVAIL(const X509V3_EXT_METHOD *method, X509V3_CTX *ctx, const char *str)
{
    return ASN1_NULL_new();
}

/*
 * The noRevAvail X.509v3 extension is defined in ITU Recommendation X.509
 * (2019), Section 17.2.2.7. See: https://www.itu.int/rec/T-REC-X.509-201910-I/en.
 */
const X509V3_EXT_METHOD ossl_v3_no_rev_avail = {
    NID_no_rev_avail, 0, ASN1_ITEM_ref(ASN1_NULL),
    0, 0, 0, 0,
    (X509V3_EXT_I2S)i2s_NO_REV_AVAIL,
    (X509V3_EXT_S2I)s2i_NO_REV_AVAIL,
    0, 0,
    (X509V3_EXT_I2R)i2r_NO_REV_AVAIL,
    (X509V3_EXT_R2I)r2i_NO_REV_AVAIL,
    NULL
};
