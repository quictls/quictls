/*
 * Generated by util/mkerr.pl DO NOT EDIT
 * Copyright 1995-2021 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OSSL_E_DASYNC_ERR_H
# define OSSL_E_DASYNC_ERR_H

# include <openssl/opensslconf.h>


# define DASYNCerr(f, r) ERR_DASYNC_error(0, (r), OPENSSL_FILE, OPENSSL_LINE)


/*
 * DASYNC reason codes.
 */
# define DASYNC_R_INIT_FAILED                             100

#endif
