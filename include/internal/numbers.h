/*
 * Copyright 2015-2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OSSL_INTERNAL_NUMBERS_H
# define OSSL_INTERNAL_NUMBERS_H

# include <limits.h>

/*
 * These macros are used to get the standard C {type}_MAX if the
 * platform doesn't have 128-bit integers. For two's-complement
 * machines.
 */
# define OSSL_MAXUINT__(T) ((T) -1)
# define OSSL_MAXINT__(T) ((T) ((((T) 1) << ((sizeof(T) * CHAR_BIT) - 1)) ^ __MAXUINT__(T)))
# define OSSL_MININT__(T) (-OSSL_MAXINT__(T) - 1)

# ifndef INT128_MAX
#  if defined(__SIZEOF_INT128__) && __SIZEOF_INT128__ == 16
typedef __int128_t int128_t;
typedef __uint128_t uint128_t;
#   define INT128_MIN OSSL_MININT__(int128_t)
#   define INT128_MAX OSSL_MAXINT__(int128_t)
#   define UINT128_MAX OSSL_MAXUINT__(uint128_t)
#  endif
# endif

#endif

