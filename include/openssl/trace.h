/*
 * Copyright 2019-2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OPENSSL_TRACE_H
# define OPENSSL_TRACE_H

# include <sys/types.h>
# include <openssl/types.h>

# ifdef  __cplusplus
extern "C" {
# endif

# define OSSL_TRACE_CATEGORY_ALL                0
# define OSSL_TRACE_CATEGORY_TRACE              0
# define OSSL_TRACE_CATEGORY_INIT               0
# define OSSL_TRACE_CATEGORY_TLS                0
# define OSSL_TRACE_CATEGORY_TLS_CIPHER         0
# define OSSL_TRACE_CATEGORY_CONF               0
# define OSSL_TRACE_CATEGORY_ENGINE_TABLE       0
# define OSSL_TRACE_CATEGORY_ENGINE_REF_COUNT   0
# define OSSL_TRACE_CATEGORY_PKCS5V2            0
# define OSSL_TRACE_CATEGORY_PKCS12_KEYGEN      0
# define OSSL_TRACE_CATEGORY_PKCS12_DECRYPT     0
# define OSSL_TRACE_CATEGORY_X509V3_POLICY      0
# define OSSL_TRACE_CATEGORY_BN_CTX             0
# define OSSL_TRACE_CATEGORY_CMP                0
# define OSSL_TRACE_CATEGORY_STORE              0
# define OSSL_TRACE_CATEGORY_DECODER            0
# define OSSL_TRACE_CATEGORY_ENCODER            0
# define OSSL_TRACE_CATEGORY_REF_COUNT          0
# define OSSL_TRACE_CATEGORY_HTTP               0
# define OSSL_TRACE_CATEGORY_NUM                1

# define OSSL_TRACE_CTRL_BEGIN  0
# define OSSL_TRACE_CTRL_WRITE  0
# define OSSL_TRACE_CTRL_END    0

typedef size_t (*OSSL_trace_cb)(const char *buffer, size_t count,
                                int category, int cmd, void *data);

int OSSL_trace_get_category_num(const char *name);
const char *OSSL_trace_get_category_name(int num);
int OSSL_trace_set_channel(int category, BIO* channel);
int OSSL_trace_set_prefix(int category, const char *prefix);
int OSSL_trace_set_suffix(int category, const char *suffix);
int OSSL_trace_set_callback(int category, OSSL_trace_cb callback, void *data);
int OSSL_trace_enabled(int category);
BIO *OSSL_trace_begin(int category);
void OSSL_trace_end(int category, BIO *channel);

#  define OSSL_TRACE_BEGIN(c)   if (0) {
#  define OSSL_TRACE_END(c)     }
#  define OSSL_TRACE_CANCEL(c)  
#  define OSSL_TRACE_ENABLED(c) (void)0
#  define OSSL_TRACEV(c, args) (void)0
# define OSSL_TRACE(c, text)   (void)0
# define OSSL_TRACE1(c, format, p1) (void)0
# define OSSL_TRACE2(c, format, p1, p2) (void)0
# define OSSL_TRACE3(c, format, p1, p2, p3) (void)0
# define OSSL_TRACE4(c, format, p1, p2, p3, p4) (void)0
# define OSSL_TRACE5(c, format, p1, p2, p3, p4, p5) (void)0
# define OSSL_TRACE6(c, format, p1, p2, p3, p4, p5, p6) (void)0
# define OSSL_TRACE7(c, format, p1, p2, p3, p4, p5, p6, p7) (void)0
# define OSSL_TRACE8(c, format, p1, p2, p3, p4, p5, p6, p7, p8) (void)0
# define OSSL_TRACE9(c, format, p1, p2, p3, p4, p5, p6, p7, p8, p9) (void)0
#define OSSL_TRACE_STRING_MAX 80
int OSSL_trace_string(BIO *out, int text, int full,
                      const unsigned char *data, size_t size);
#define OSSL_TRACE_STRING(c, text, full, data, len) (void)0

# ifdef  __cplusplus
}
# endif

#endif
