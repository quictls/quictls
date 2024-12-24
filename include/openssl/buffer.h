/*
 * Copyright 1995-2018 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OPENSSL_BUFFER_H
# define OPENSSL_BUFFER_H

# include <openssl/macros.h>
# include <openssl/types.h>
# ifndef OPENSSL_CRYPTO_H
#  include <openssl/crypto.h>
# endif
# include <openssl/buffererr.h>


#ifdef  __cplusplus
extern "C" {
#endif

# include <stddef.h>
# include <sys/types.h>

struct buf_mem_st {
    size_t length;              /* current number of bytes */
    char *data;
    size_t max;                 /* size of buffer */
    unsigned long flags;
};

# define BUF_MEM_FLAG_SECURE  0x01

BUF_MEM *BUF_MEM_new(void);
BUF_MEM *BUF_MEM_new_ex(unsigned long flags);
void BUF_MEM_free(BUF_MEM *a);
size_t BUF_MEM_grow(BUF_MEM *str, size_t len);
size_t BUF_MEM_grow_clean(BUF_MEM *str, size_t len);
void BUF_reverse(unsigned char *out, const unsigned char *in, size_t siz);


# ifdef  __cplusplus
}
# endif
#endif
