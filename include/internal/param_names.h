/*
 * Copyright 2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OSSL_INTERNAL_PARAM_NAMES_H
# define OSSL_INTERNAL_PARAM_NAMES_H
# pragma once
# include <internal/param_names.inc>

# ifdef  __cplusplus
extern "C" {
# endif
int ossl_param_find_pidx(const char *s);
# ifdef  __cplusplus
}
# endif

#endif
