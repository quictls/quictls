/*
 * Copyright 2020-2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <openssl/trace.h>
#include <apps/apps.h>
#include <apps/log.h>

void trace_log_message(const char *prog, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    BIO_vprintf(bio_err, fmt, ap);
    va_end(ap);
}
