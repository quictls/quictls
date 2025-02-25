/*
 * Copyright 1995-2023 The OpenSSL Project Authors. All Rights Reserved.
 * Copyright 2025 The QuicTLS Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <apps/apps.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include <openssl/rand.h>
#include <openssl/conf.h>

/*
 * See comments in opt_verify for explanation of this.
 */
enum r_range { OPT_R_ENUM };

int opt_rand(int opt)
{
    switch ((enum r_range)opt) {
    case OPT_R__FIRST:
    case OPT_R__LAST:
        break;
    case OPT_R_RAND:
        opt_printf_stderr("%s: Legacy rand option \"%s\" ignored.\n",
                opt_appname(NULL), "-rand");
        break;
    case OPT_R_WRITERAND:
        opt_printf_stderr("%s: Legacy rand option \"%s\" ignored.\n",
                opt_appname(NULL), "-writerand");
        break;
    }
    return 1;
}
