/*
 * Copyright 1995-2021 The OpenSSL Project Authors. All Rights Reserved.
 * Copyright 2025, the QuicTLS Projeccdt Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include <openssl/crypto.h>
#include <openssl/rand.h>

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#ifndef OPENSSL_NO_POSIX_IO
# include <sys/stat.h>
# if defined(_WIN32) && !defined(_WIN32_WCE)
#  include <windows.h>
#  include <io.h>
#  define stat    _stat
#  define open    _open
#  define fdopen  _fdopen
# endif
#endif

/* 256 bytes of entropy is probably enough for an obsolete API. */
#define RAND_BUF_SIZE 256

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
    /* Only write to plain files.  TOCTOU issue. */
    struct stat sb;
    if (stat(file, &sb) < 0 || !S_ISREG(sb.st_mode))
        return -1;

    int fd = open(file, O_WRONLY|O_CREAT, 0600);
    if (fd < 0)
        return -1;

    unsigned char buff[RAND_BUF_SIZE];
    if (RAND_bytes(buff, sizeof buff) != 1) {
        close(fd);
        return -1;
    }

    FILE *out = fdopen(fd, "wb");
    if (out == NULL) {
        close(fd);
        return -1;
    }

    if (fwrite(buff, sizeof buff, 1, out) != sizeof buff) {
        fclose(out);
        return -1;
    }

    fclose(out);
    OPENSSL_cleanse(buff, sizeof buff);
    return (int)sizeof buff;;

}

const char *RAND_file_name(char *buff, size_t size)
{
    /* Not portable, but good enough since this should not be used. */
    if (OPENSSL_strlcpy(buff, "/dev/urandom", size) >= size)
        return NULL;
    return buff;
}
