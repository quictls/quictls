/*
 * Copyright 1999-2020 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OPENSSL_OPENSSLV_H
# define OPENSSL_OPENSSLV_H
# ifndef OPENSSL_CONFIGURATION_H
#  include <openssl/configuration.h>
# endif

/* These lines are a hack to to make CMake work */
# undef OPENSSL_VERSION_STR
# define OPENSSL_VERSION_STR "3.3.0"
# undef OPENSSL_FULL_VERSION_STR
# define OPENSSL_FULL_VERSION_STR "3.3.0+quic"

#endif
