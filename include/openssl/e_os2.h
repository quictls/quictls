/*
 * Copyright 1995-2023 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OPENSSL_E_OS2_H
# define OPENSSL_E_OS2_H

# include <openssl/macros.h>
# include <openssl/opensslconf.h>

#ifdef  __cplusplus
extern "C" {
#endif

/******************************************************************************
 * Detect operating systems.  This probably needs completing.
 * The result is that at least one OPENSSL_SYS_os macro should be defined.
 * However, if none is defined, Unix is assumed.
 **/

# define OPENSSL_SYS_UNIX

/* --------------------- Microsoft operating systems ---------------------- */

/*
 * Note that MSDOS actually denotes 32-bit environments running on top of
 * MS-DOS.
 */
# if defined(OPENSSL_SYS_MSDOS)
#  undef OPENSSL_SYS_UNIX
# endif

/*
 * For 32 bit environment, there seems to be the CygWin environment and then
 * all the others that try to do the same thing Microsoft does...
 */
/*
 * UEFI lives here because it might be built with a Microsoft toolchain and
 * we need to avoid the false positive match on Windows.
 */
# if defined(OPENSSL_SYS_UEFI)
#  undef OPENSSL_SYS_UNIX
# else
#  if defined(__CYGWIN__) || defined(OPENSSL_SYS_CYGWIN)
#   define OPENSSL_SYS_WIN32_CYGWIN
#  else
#   if defined(_WIN32) || defined(OPENSSL_SYS_WIN32)
#    undef OPENSSL_SYS_UNIX
#    if !defined(OPENSSL_SYS_WIN32)
#     define OPENSSL_SYS_WIN32
#    endif
#   endif
#   if defined(_WIN64) || defined(OPENSSL_SYS_WIN64)
#    undef OPENSSL_SYS_UNIX
#    if !defined(OPENSSL_SYS_WIN64)
#     define OPENSSL_SYS_WIN64
#    endif
#   endif
#   if defined(OPENSSL_SYS_WINNT)
#    undef OPENSSL_SYS_UNIX
#   endif
#  endif
# endif

/* Anything that tries to look like Microsoft is "Windows" */
# if defined(OPENSSL_SYS_WIN32) || defined(OPENSSL_SYS_WIN64) || defined(OPENSSL_SYS_WINNT)
#  undef OPENSSL_SYS_UNIX
#  define OPENSSL_SYS_WINDOWS
#  ifndef OPENSSL_SYS_MSDOS
#   define OPENSSL_SYS_MSDOS
#  endif
# endif

/* -------------------------------- Unix ---------------------------------- */
# ifdef OPENSSL_SYS_UNIX
#  if defined(linux) || defined(__linux__) && !defined(OPENSSL_SYS_LINUX)
#   define OPENSSL_SYS_LINUX
#  endif
#  if defined(_AIX) && !defined(OPENSSL_SYS_AIX)
#   define OPENSSL_SYS_AIX
#  endif
# endif

/**
 * That's it for OS-specific stuff
 *****************************************************************************/

/*-
 * OPENSSL_EXTERN is normally used to declare a symbol with possible extra
 * attributes to handle its presence in a shared library.
 * OPENSSL_EXPORT is used to define a symbol with extra possible attributes
 * to make it visible in a shared library.
 * Care needs to be taken when a header file is used both to declare and
 * define symbols.  Basically, for any library that exports some global
 * variables, the following code must be present in the header file that
 * declares them, before OPENSSL_EXTERN is used:
 *
 * #ifdef SOME_BUILD_FLAG_MACRO
 * # undef OPENSSL_EXTERN
 * # define OPENSSL_EXTERN OPENSSL_EXPORT
 * #endif
 *
 * The default is to have OPENSSL_EXPORT and OPENSSL_EXTERN
 * have some generally sensible values.
 */

# if defined(OPENSSL_SYS_WINDOWS) && defined(_WINDLL)
#  define OPENSSL_EXPORT extern __declspec(dllexport)
#  define OPENSSL_EXTERN extern __declspec(dllimport)
# else
#  define OPENSSL_EXPORT extern
#  define OPENSSL_EXTERN extern
# endif

# ifdef _WIN32
#  ifdef _WIN64
#   define ossl_ssize_t __int64
#   define OSSL_SSIZE_MAX _I64_MAX
#  else
#   define ossl_ssize_t int
#   define OSSL_SSIZE_MAX INT_MAX
#  endif
# endif

# if defined(OPENSSL_SYS_UEFI) && !defined(ossl_ssize_t)
#  define ossl_ssize_t INTN
#  define OSSL_SSIZE_MAX MAX_INTN
# endif

# ifndef ossl_ssize_t
#  define ossl_ssize_t ssize_t
#  if defined(SSIZE_MAX)
#   define OSSL_SSIZE_MAX SSIZE_MAX
#  elif defined(_POSIX_SSIZE_MAX)
#   define OSSL_SSIZE_MAX _POSIX_SSIZE_MAX
#  else
#   define OSSL_SSIZE_MAX ((ssize_t)(SIZE_MAX>>1))
#  endif
# endif

# if defined(UNUSEDRESULT_DEBUG)
#  define __owur __attribute__((__warn_unused_result__))
# else
#  define __owur
# endif

# include <inttypes.h>

# if defined(OPENSSL_SYS_UEFI)
typedef INT8 int8_t;
typedef UINT8 uint8_t;
typedef INT16 int16_t;
typedef UINT16 uint16_t;
typedef INT32 int32_t;
typedef UINT32 uint32_t;
typedef INT64 int64_t;
typedef UINT64 uint64_t;
# endif

# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L \
        && !defined(__cplusplus)
#  define ossl_noreturn _Noreturn
# elif defined(__GNUC__) && __GNUC__ >= 2
#  define ossl_noreturn __attribute__((noreturn))
# else
#  define ossl_noreturn /* unsupported */
# endif

/* ossl_unused: portable unused attribute for use in public headers */
# if defined(__GNUC__)
#  define ossl_unused __attribute__((unused))
# else
#  define ossl_unused /* unsupported */
# endif

#ifdef  __cplusplus
}
#endif
#endif
