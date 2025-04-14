/*
 * Copyright 1995-2021 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <internal/cryptlib.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <openssl/crypto.h>
#include <openssl/rand.h>
#include <openssl/buffer.h>

#include <sys/types.h>
#ifndef OPENSSL_NO_POSIX_IO
# include <sys/stat.h>
# include <fcntl.h>
# if defined(_WIN32) && !defined(_WIN32_WCE)
#  include <windows.h>
#  include <io.h>
#  define stat    _stat
#  define chmod   _chmod
#  define open    _open
#  define fdopen  _fdopen
#  define fstat   _fstat
#  define fileno  _fileno
# endif
#endif

/*
 * Following should not be needed, and we could have been stricter
 * and demand S_IS*. But some systems just don't comply... Formally
 * below macros are "anatomically incorrect", because normally they
 * would look like ((m) & MASK == TYPE), but since MASK availability
 * is as questionable, we settle for this poor-man fallback...
 */
# if !defined(S_ISREG)
#   define S_ISREG(m) ((m) & S_IFREG)
# endif

#define RAND_BUF_SIZE 1024
#define RFILE ".rnd"

/*
 * Note that these functions are intended for seed files only. Entropy
 * devices are handled in rand_unix.c  If |bytes| is -1 read the
 * complete file; otherwise read the specified amount.
 */
int RAND_load_file(const char *file, long bytes)
{
    return -1;
}

int RAND_write_file(const char *file)
{
    return -1;
}

const char *RAND_file_name(char *buf, size_t size)
{
    return NULL;
}
