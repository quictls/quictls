/*
 * Copyright 1995-2021 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <stdio.h>
#include <errno.h>
#include "bio_local.h"
#include <internal/cryptlib.h>

static int null_write(BIO *h, const char *buf, int num);
static int null_read(BIO *h, char *buf, int size);
static int null_puts(BIO *h, const char *str);
static int null_gets(BIO *h, char *str, int size);
static long null_ctrl(BIO *h, int cmd, long arg1, void *arg2);

static const BIO_METHOD null_method = {
    .type = BIO_TYPE_NULL,
    .name = "NULL",
    .bwrite = bwrite_conv,
    .bwrite_old = null_write,
    .bread = bread_conv,
    .bread_old = null_read,
    .bputs = null_puts,
    .bgets = null_gets,
    .ctrl = null_ctrl,
    .create = NULL,
    .destroy = NULL,
    .callback_ctrl = NULL,
    .bsendmmsg = NULL,
    .brecvmmsg = NULL,
};

const BIO_METHOD *BIO_s_null(void)
{
    return &null_method;
}

static int null_read(BIO *b, char *out, int outl)
{
    return 0;
}

static int null_write(BIO *b, const char *in, int inl)
{
    return inl;
}

static long null_ctrl(BIO *b, int cmd, long num, void *ptr)
{
    long ret = 1;

    switch (cmd) {
    case BIO_CTRL_RESET:
    case BIO_CTRL_EOF:
    case BIO_CTRL_SET:
    case BIO_CTRL_SET_CLOSE:
    case BIO_CTRL_FLUSH:
    case BIO_CTRL_DUP:
        ret = 1;
        break;
    case BIO_CTRL_GET_CLOSE:
    case BIO_CTRL_INFO:
    case BIO_CTRL_GET:
    case BIO_CTRL_PENDING:
    case BIO_CTRL_WPENDING:
    default:
        ret = 0;
        break;
    }
    return ret;
}

static int null_gets(BIO *bp, char *buf, int size)
{
    return 0;
}

static int null_puts(BIO *bp, const char *str)
{
    if (str == NULL)
        return 0;
    return strlen(str);
}
