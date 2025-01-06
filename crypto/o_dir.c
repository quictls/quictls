/*
 * Copyright 2004-2022 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

/*
 * This file is dual-licensed and is also available under the following
 * terms:
 *
 * Copyright (c) 2004, Richard Levitte <richard@levitte.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <openssl/crypto.h>
#include <errno.h>
#include <internal/o_dir.h>

#if defined OPENSSL_SYS_WIN32

# include <windows.h>
# include <tchar.h>
# include <internal/numbers.h>

# ifdef CP_UTF8
#  define CP_DEFAULT CP_UTF8
# else
#  define CP_DEFAULT CP_ACP
# endif

struct OPENSSL_dir_context_st {
    WIN32_FIND_DATA ctx;
    HANDLE handle;
    char entry_name[255 + 1];
};

const char *OPENSSL_DIR_read(OPENSSL_DIR_CTX **ctx, const char *directory)
{
    if (ctx == NULL || directory == NULL) {
        errno = EINVAL;
        return 0;
    }

    errno = 0;
    if (*ctx == NULL) {
        size_t dirlen = strlen(directory);

        if (dirlen == 0 || dirlen > INT_MAX - 3) {
            errno = ENOENT;
            return 0;
        }

        *ctx = malloc(sizeof(**ctx));
        if (*ctx == NULL) {
            errno = ENOMEM;
            return 0;
        }
        memset(*ctx, 0, sizeof(**ctx));

        if (sizeof(TCHAR) != sizeof(char)) {
            TCHAR *wdir = NULL;
            /* len_0 denotes string length *with* trailing 0 */
            size_t index = 0, len_0 = dirlen + 1;
            int sz = 0;
            UINT cp;

            do {
# ifdef CP_UTF8
                cp = CP_UTF8;
                sz = MultiByteToWideChar(cp, 0, directory, len_0, NULL, 0);
                if (sz > 0
                        || GetLastError() != ERROR_NO_UNICODE_TRANSLATION)
                    break;
# endif
                cp = CP_ACP;
                sz = MultiByteToWideChar(cp, 0, directory, len_0, NULL, 0);
            } while (0);

            if (sz > 0) {
                /*
                 * allocate two additional characters in case we need to
                 * concatenate asterisk, |sz| covers trailing '\0'!
                 */
                wdir = _alloca((sz + 2) * sizeof(TCHAR));
                if (!MultiByteToWideChar(cp, 0, directory, len_0,
                                         (WCHAR *)wdir, sz)) {
                    free(*ctx);
                    *ctx = NULL;
                    errno = EINVAL;
                    return 0;
                }
            } else {
                sz = len_0;
                /*
                 * allocate two additional characters in case we need to
                 * concatenate asterisk, |sz| covers trailing '\0'!
                 */
                wdir = _alloca((sz + 2) * sizeof(TCHAR));
                for (index = 0; index < len_0; index++)
                    wdir[index] = (TCHAR)directory[index];
            }

            sz--; /* wdir[sz] is trailing '\0' now */
            if (wdir[sz - 1] != TEXT('*')) {
                if (wdir[sz - 1] != TEXT('/') && wdir[sz - 1] != TEXT('\\'))
                    _tcscpy(wdir + sz, TEXT("/*"));
                else
                    _tcscpy(wdir + sz, TEXT("*"));
            }

            (*ctx)->handle = FindFirstFile(wdir, &(*ctx)->ctx);
        } else {
            if (directory[dirlen - 1] != '*') {
                char *buf = _alloca(dirlen + 3);

                strcpy(buf, directory);
                if (buf[dirlen - 1] != '/' && buf[dirlen - 1] != '\\')
                    strcpy(buf + dirlen, "/*");
                else
                    strcpy(buf + dirlen, "*");

                directory = buf;
            }

            (*ctx)->handle = FindFirstFile((TCHAR *)directory, &(*ctx)->ctx);
        }

        if ((*ctx)->handle == INVALID_HANDLE_VALUE) {
            free(*ctx);
            *ctx = NULL;
            errno = EINVAL;
            return 0;
        }
    } else {
        if (FindNextFile((*ctx)->handle, &(*ctx)->ctx) == FALSE) {
            return 0;
        }
    }
    if (sizeof(TCHAR) != sizeof(char)) {
        TCHAR *wdir = (*ctx)->ctx.cFileName;
        size_t index, len_0 = 0;

        while (wdir[len_0] && len_0 < (sizeof((*ctx)->entry_name) - 1))
            len_0++;
        len_0++;

        if (!WideCharToMultiByte(CP_DEFAULT, 0, (WCHAR *)wdir, len_0,
                                 (*ctx)->entry_name,
                                 sizeof((*ctx)->entry_name), NULL, 0))
            for (index = 0; index < len_0; index++)
                (*ctx)->entry_name[index] = (char)wdir[index];
    } else
        strncpy((*ctx)->entry_name, (const char *)(*ctx)->ctx.cFileName,
                sizeof((*ctx)->entry_name) - 1);

    (*ctx)->entry_name[sizeof((*ctx)->entry_name) - 1] = '\0';

    return (*ctx)->entry_name;
}

int OPENSSL_DIR_end(OPENSSL_DIR_CTX **ctx)
{
    if (ctx != NULL && *ctx != NULL) {
        FindClose((*ctx)->handle);
        free(*ctx);
        *ctx = NULL;
        return 1;
    }
    errno = EINVAL;
    return 0;
}

#else

# include <stddef.h>
# include <stdlib.h>
# include <limits.h>
# include <string.h>
# include <sys/types.h>
# include <dirent.h>
# include <errno.h>

struct OPENSSL_dir_context_st {
    DIR *dir;
    char entry_name[256 + 1];
};

const char *OPENSSL_DIR_read(OPENSSL_DIR_CTX **ctx, const char *directory)
{
    struct dirent *direntry = NULL;

    if (ctx == NULL || directory == NULL) {
        errno = EINVAL;
        return 0;
    }

    errno = 0;
    if (*ctx == NULL) {
        *ctx = malloc(sizeof(**ctx));
        if (*ctx == NULL) {
            errno = ENOMEM;
            return 0;
        }
        memset(*ctx, 0, sizeof(**ctx));


        (*ctx)->dir = opendir(directory);
        if ((*ctx)->dir == NULL) {
            int save_errno = errno; /* Probably not needed, but I'm paranoid */
            free(*ctx);
            *ctx = NULL;
            errno = save_errno;
            return 0;
        }
    }


    direntry = readdir((*ctx)->dir);
    if (direntry == NULL) {
        return 0;
    }

    OPENSSL_strlcpy((*ctx)->entry_name, direntry->d_name,
                    sizeof((*ctx)->entry_name));
    return (*ctx)->entry_name;
}

int OPENSSL_DIR_end(OPENSSL_DIR_CTX **ctx)
{
    if (ctx != NULL && *ctx != NULL) {
        int ret = closedir((*ctx)->dir);

        free(*ctx);
        switch (ret) {
        case 0:
            return 1;
        case -1:
            return 0;
        default:
            break;
        }
    }
    errno = EINVAL;
    return 0;
}
#endif
