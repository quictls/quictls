/*
 * Copyright 1995-2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include "internal/e_os.h"
#include "internal/cryptlib.h"
#include "crypto/cryptlib.h"
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <openssl/crypto.h>

/*
 * the following pointers may be changed as long as 'allow_customize' is set
 */
static int allow_customize = 1;
static CRYPTO_malloc_fn malloc_impl = CRYPTO_malloc;
static CRYPTO_realloc_fn realloc_impl = CRYPTO_realloc;
static CRYPTO_free_fn free_impl = CRYPTO_free;

int CRYPTO_set_mem_functions(CRYPTO_malloc_fn malloc_fn,
                             CRYPTO_realloc_fn realloc_fn,
                             CRYPTO_free_fn free_fn)
{
    if (!allow_customize)
        return 0;
    if (malloc_fn != NULL)
        malloc_impl = malloc_fn;
    if (realloc_fn != NULL)
        realloc_impl = realloc_fn;
    if (free_fn != NULL)
        free_impl = free_fn;
    return 1;
}

void CRYPTO_get_mem_functions(CRYPTO_malloc_fn *malloc_fn,
                              CRYPTO_realloc_fn *realloc_fn,
                              CRYPTO_free_fn *free_fn)
{
    if (malloc_fn != NULL)
        *malloc_fn = malloc_impl;
    if (realloc_fn != NULL)
        *realloc_fn = realloc_impl;
    if (free_fn != NULL)
        *free_fn = free_impl;
}

void *CRYPTO_malloc(size_t num, const char *file, int line)
{
    void *ptr;

    if (malloc_impl != CRYPTO_malloc) {
        ptr = malloc_impl(num, file, line);
        if (ptr != NULL || num == 0)
            return ptr;
        goto err;
    }

    if (num == 0)
        return NULL;

    if (allow_customize) {
        /*
         * Disallow customization after the first allocation. We only set this
         * if necessary to avoid a store to the same cache line on every
         * allocation.
         */
        allow_customize = 0;
    }

    ptr = malloc(num);
    if (ptr != NULL)
        return ptr;
 err:
    /*
     * ossl_err_get_state_int() in err.c uses CRYPTO_zalloc(num, NULL, 0) for
     * ERR_STATE allocation. Prevent mem alloc error loop while reporting error.
     */
    if (file != NULL || line != 0) {
        ERR_new();
        ERR_set_debug(file, line, NULL);
        ERR_set_error(ERR_LIB_CRYPTO, ERR_R_MALLOC_FAILURE, NULL);
    }
    return NULL;
}

void *CRYPTO_zalloc(size_t num, const char *file, int line)
{
    void *ret;

    ret = CRYPTO_malloc(num, file, line);
    if (ret != NULL)
        memset(ret, 0, num);

    return ret;
}

void *CRYPTO_realloc(void *str, size_t num, const char *file, int line)
{
    if (realloc_impl != CRYPTO_realloc)
        return realloc_impl(str, num, file, line);

    if (str == NULL)
        return CRYPTO_malloc(num, file, line);

    if (num == 0) {
        CRYPTO_free(str, file, line);
        return NULL;
    }

    return realloc(str, num);
}

void *CRYPTO_clear_realloc(void *str, size_t old_len, size_t num,
                           const char *file, int line)
{
    void *ret = NULL;

    if (str == NULL)
        return CRYPTO_malloc(num, file, line);

    if (num == 0) {
        CRYPTO_clear_free(str, old_len, file, line);
        return NULL;
    }

    /* Can't shrink the buffer since memcpy below copies |old_len| bytes. */
    if (num < old_len) {
        OPENSSL_cleanse((char*)str + num, old_len - num);
        return str;
    }

    ret = CRYPTO_malloc(num, file, line);
    if (ret != NULL) {
        memcpy(ret, str, old_len);
        CRYPTO_clear_free(str, old_len, file, line);
    }
    return ret;
}

void CRYPTO_free(void *str, const char *file, int line)
{
    if (free_impl != CRYPTO_free) {
        free_impl(str, file, line);
        return;
    }

    free(str);
}

void CRYPTO_clear_free(void *str, size_t num, const char *file, int line)
{
    if (str == NULL)
        return;
    if (num)
        OPENSSL_cleanse(str, num);
    CRYPTO_free(str, file, line);
}

#ifndef OPENSSL_NO_DEPRECATED_3_0
int CRYPTO_mem_ctrl(int mode)
{
    (void)mode;
    return -1;
}

int CRYPTO_set_mem_debug(int flag)
{
    (void)flag;
    return -1;
}

int CRYPTO_mem_debug_push(const char *info, const char *file, int line)
{
    (void)info; (void)file; (void)line;
    return 0;
}

int CRYPTO_mem_debug_pop(void)
{
    return 0;
}

void CRYPTO_mem_debug_malloc(void *addr, size_t num, int flag,
                             const char *file, int line)
{
    (void)addr; (void)num; (void)flag; (void)file; (void)line;
}

void CRYPTO_mem_debug_realloc(void *addr1, void *addr2, size_t num, int flag,
                              const char *file, int line)
{
    (void)addr1; (void)addr2; (void)num; (void)flag; (void)file; (void)line;
}

void CRYPTO_mem_debug_free(void *addr, int flag,
                           const char *file, int line)
{
    (void)addr; (void)flag; (void)file; (void)line;
}

int CRYPTO_mem_leaks(BIO *b)
{
    (void)b;
    return -1;
}

# ifndef OPENSSL_NO_STDIO
int CRYPTO_mem_leaks_fp(FILE *fp)
{
    (void)fp;
    return -1;
}
# endif

int CRYPTO_mem_leaks_cb(int (*cb)(const char *str, size_t len, void *u),
                        void *u)
{
    (void)cb; (void)u;
    return -1;
}

#endif

