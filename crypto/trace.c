/*
 * Copyright 2019-2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <stdio.h>
#include <string.h>

#include <internal/thread_once.h>
#include <openssl/bio.h>
#include <openssl/crypto.h>
#include <openssl/trace.h>
#include <internal/bio.h>
#include <internal/nelem.h>
#include <internal/refcount.h>
#include <crypto/cryptlib.h>
#include <crypto/ctype.h>


const char *OSSL_trace_get_category_name(int num)
{
    return NULL;
}

int OSSL_trace_get_category_num(const char *name)
{
    return -1; /* not found */
}

void ossl_trace_cleanup(void)
{
}

int OSSL_trace_set_channel(int category, BIO *channel)
{
    return 0;
}

int OSSL_trace_set_callback(int category, OSSL_trace_cb callback, void *data)
{
    return 0;
}

int OSSL_trace_set_prefix(int category, const char *prefix)
{
    return 0;
}

int OSSL_trace_set_suffix(int category, const char *suffix)
{
    return 0;
}

int OSSL_trace_enabled(int category)
{
    return 0;
}

BIO *OSSL_trace_begin(int category)
{
    return NULL;
}

void OSSL_trace_end(int category, BIO *channel)
{
}

int OSSL_trace_string(BIO *out, int text, int full,
                      const unsigned char *data, size_t size)
{
    return -1;
}
