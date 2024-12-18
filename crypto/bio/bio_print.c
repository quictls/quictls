/*
 * Copyright 1995-2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <stdio.h>
#include "internal/cryptlib.h"
#include <openssl/bio.h>
#include <openssl/configuration.h>

int BIO_printf(BIO *bio, const char *format, ...)
{
    va_list args;
    int ret;

    va_start(args, format);
    ret = BIO_vprintf(bio, format, args);
    va_end(args);
    return ret;
}

int BIO_vprintf(BIO *bio, const char *format, va_list args)
{
    int ret, i = -1;
    char buff[1024];
    va_list copy;

    /* Does it fit in the fixed buffer? */
    va_copy(copy, args);
    ret = vsnprintf(buff, sizeof(buff), format, args);
    if (ret < (int)sizeof(buff))
        i = BIO_write(bio, buff, ret);
    else {
        /* Allocate enough space and try again. */
        int size = ret + 1;
        char *p = OPENSSL_malloc(size);

        if (p != NULL) {
            ret = vsnprintf(p, size, format, copy);
            if (ret < size)
                i = BIO_write(bio, p, ret);
            OPENSSL_free(p);
        }
    }
    va_end(copy);
    return i;
}

/*
 * This is a wrapper around snprintf, but returns -1 if the
 * buffer is too small (documented behavior).
 */
int BIO_snprintf(char *buff, size_t n, const char *format, ...)
{
    va_list args;
    int ret;

    va_start(args, format);
    ret = vsnprintf(buff, n, format, args);
    va_end(args);
    return (size_t)ret > n ? -1 : ret;
}

/*
 * This is a wrapper around vsnprintf, but returns -1 if the
 * buffer is too small (documented).
 */
int BIO_vsnprintf(char *buff, size_t n, const char *format, va_list args)
{
    int ret;

    ret = vsnprintf(buff, n, format, args);
    return (size_t)ret > n ? -1 : ret;
}
