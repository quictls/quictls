/*
 * Copyright 1995-2022 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OSSL_APPS_LOG_H
# define OSSL_APPS_LOG_H

# include <openssl/bio.h>

void trace_log_message(const char *prog, const char *fmt, ...);

#endif /* OSSL_APPS_LOG_H */
