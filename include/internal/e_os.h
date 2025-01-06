/*
 * Copyright 1995-2024 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OSSL_E_OS_H
# define OSSL_E_OS_H

# include <limits.h>
# include <openssl/opensslconf.h>

# include <openssl/e_os2.h>
# include <openssl/crypto.h>
# include <internal/numbers.h>   /* Ensure the definition of SIZE_MAX */

/*
 * <openssl/e_os2.h> contains what we can justify to make visible to the
 * outside; this file e_os.h is not part of the exported interface.
 */

# if defined(OPENSSL_SYS_VXWORKS) || defined(OPENSSL_SYS_UEFI)
#  define NO_CHMOD
#  define NO_SYSLOG
# endif

# define get_last_sys_error()    errno
# define clear_sys_error()       errno=0
# define set_sys_error(e)        errno=(e)

/********************************************************************
 The Microsoft section
 ********************************************************************/
# if defined(OPENSSL_SYS_WIN32) && !defined(WIN32)
#  define WIN32
# endif
# if defined(OPENSSL_SYS_WINDOWS) && !defined(WINDOWS)
#  define WINDOWS
# endif
# if defined(OPENSSL_SYS_MSDOS) && !defined(MSDOS)
#  define MSDOS
# endif

# ifdef WIN32
#  undef get_last_sys_error
#  undef clear_sys_error
#  undef set_sys_error
#  define get_last_sys_error()    GetLastError()
#  define clear_sys_error()       SetLastError(0)
#  define set_sys_error(e)        SetLastError(e)
#  if !defined(WINNT)
#   define WIN_CONSOLE_BUG
#  endif
# else
# endif

# if (defined(WINDOWS) || defined(MSDOS))

#  ifndef S_IFDIR
#   define S_IFDIR     _S_IFDIR
#  endif

#  ifndef S_IFMT
#   define S_IFMT      _S_IFMT
#  endif

#  if !defined(WINNT)
#   define NO_SYSLOG
#  endif

#  ifdef WINDOWS
#   if !defined(_WIN32_WCE) && !defined(_WIN32_WINNT)
       /*
        * Defining _WIN32_WINNT here in e_os.h implies certain "discipline."
        * Most notably we ought to check for availability of each specific
        * routine that was introduced after denoted _WIN32_WINNT with
        * GetProcAddress(). Normally newer functions are masked with higher
        * _WIN32_WINNT in SDK headers. So that if you wish to use them in
        * some module, you'd need to override _WIN32_WINNT definition in
        * the target module in order to "reach for" prototypes, but replace
        * calls to new functions with indirect calls. Alternatively it
        * might be possible to achieve the goal by /DELAYLOAD-ing .DLLs
        * and check for current OS version instead.
        */
#    define _WIN32_WINNT 0x0501
#   endif
#   if defined(_WIN32_WINNT) || defined(_WIN32_WCE)
       /*
        * Just like defining _WIN32_WINNT including winsock2.h implies
        * certain "discipline" for maintaining [broad] binary compatibility.
        * As long as structures are invariant among Winsock versions,
        * it's sufficient to check for specific Winsock2 API availability
        * at run-time [DSO_global_lookup is recommended]...
        */
#    include <winsock2.h>
#    include <ws2tcpip.h>
#    include <wspiapi.h>
       /* yes, they have to be #included prior to <windows.h> */
#   endif
#   include <windows.h>
#   include <stdio.h>
#   include <stddef.h>
#   include <errno.h>
#   if defined(_WIN32_WCE) && !defined(EACCES)
#    define EACCES   13
#   endif
#   include <string.h>
#   ifdef _WIN64
#    define strlen(s) _strlen31(s)
/* cut strings to 2GB */
static __inline unsigned int _strlen31(const char *str)
{
    unsigned int len = 0;
    while (*str && len < 0x80000000U)
        str++, len++;
    return len & 0x7FFFFFFF;
}
#   endif
#   include <malloc.h>
#   if defined(_MSC_VER) && !defined(_WIN32_WCE) && !defined(_DLL) && defined(stdin)
#    if _MSC_VER>=1300 && _MSC_VER<1600
#     undef stdin
#     undef stdout
#     undef stderr
FILE *__iob_func(void);
#     define stdin  (&__iob_func()[0])
#     define stdout (&__iob_func()[1])
#     define stderr (&__iob_func()[2])
#    endif
#   endif
#  endif
#  include <io.h>
#  include <fcntl.h>

#  define EXIT(n) exit(n)
#  define LIST_SEPARATOR_CHAR ';'
#  ifndef W_OK
#   define W_OK        2
#  endif
#  ifndef R_OK
#   define R_OK        4
#  endif
#  define DEFAULT_HOME  "C:"

/* Avoid Visual Studio 13 GetVersion deprecated problems */
#  if defined(_MSC_VER) && _MSC_VER>=1800
#   define check_winnt() (1)
#   define check_win_minplat(x) (1)
#  else
#   define check_winnt() (GetVersion() < 0x80000000)
#   define check_win_minplat(x) (LOBYTE(LOWORD(GetVersion())) >= (x))
#  endif

# else                          /* The non-microsoft world */

#  if defined(OPENSSL_SYS_VXWORKS)
#   include <time.h>
#  else
#   include <sys/time.h>
#  endif

#  include <unistd.h>
#  include <sys/types.h>
#  ifdef OPENSSL_SYS_WIN32_CYGWIN
#   include <io.h>
#   include <fcntl.h>
#  endif

#  define LIST_SEPARATOR_CHAR ':'
#  define EXIT(n)             exit(n)

# endif

/***********************************************/

# if defined(OPENSSL_SYS_WINDOWS)
#  if defined(_MSC_VER) && (_MSC_VER >= 1310) && !defined(_WIN32_WCE)
#   define open _open
#   define fdopen _fdopen
#   define close _close
#   ifndef strdup
#    define strdup _strdup
#   endif
#   define unlink _unlink
#   define fileno _fileno
#   define isatty _isatty
#  endif
# else
#  include <strings.h>
# endif

/* vxworks */
# if defined(OPENSSL_SYS_VXWORKS)
#  include <ioLib.h>
#  include <tickLib.h>
#  include <sysLib.h>
#  include <vxWorks.h>
#  include <sockLib.h>
#  include <taskLib.h>

#  define TTY_STRUCT int
#  define sleep(a) taskDelay((a) * sysClkRateGet())

/*
 * NOTE: these are implemented by helpers in database app! if the database is
 * not linked, we need to implement them elsewhere
 */
struct hostent *gethostbyname(const char *name);
struct hostent *gethostbyaddr(const char *addr, int length, int type);
struct servent *getservbyname(const char *name, const char *proto);

# endif
/* end vxworks */

# ifdef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
#  define CRYPTO_memcmp memcmp
# endif

# ifndef OPENSSL_NO_SECURE_MEMORY
   /* unistd.h defines _POSIX_VERSION */
#  if (defined(OPENSSL_SYS_UNIX) \
        && ( (defined(_POSIX_VERSION) && _POSIX_VERSION >= 200112L)      \
             || defined(__sun) || defined(__hpux) || defined(__sgi)      \
             || defined(__osf__) )) \
      || defined(_WIN32)
      /* secure memory is implemented */
#   else
#     define OPENSSL_NO_SECURE_MEMORY
#   endif
# endif

/*
 * str[n]casecmp_l is defined in POSIX 2008-01. Value is taken accordingly
 * https://www.gnu.org/software/libc/manual/html_node/Feature-Test-Macros.html
 * There are also equivalent functions on Windows.
 * There is no locale_t on NONSTOP.
 */
# if defined(OPENSSL_SYS_WINDOWS)
#  define locale_t _locale_t
#  define freelocale _free_locale
#  define strcasecmp_l _stricmp_l
#  define strncasecmp_l _strnicmp_l
#  define strcasecmp _stricmp
#  define strncasecmp _strnicmp
# elif !defined(_POSIX_C_SOURCE) || _POSIX_C_SOURCE < 200809L
#  ifndef OPENSSL_NO_LOCALE
#   define OPENSSL_NO_LOCALE
#  endif
# endif

#endif
