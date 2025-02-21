QuicTLS requires [cmake](https://www.cmake.org). It also requires Perl.

Environment variables
=====================
- `LOCAL_BUILD_SETTINGS`
If this environment variable is set it is read in very early
in the `cmake` process. The most common use of this file is likely
to be setting some of the other variables described here.


Disabling large parts of the build
==================================
- `OPENSSL_NO_APPS`
Do not build the `openssl` program
- `OPENSSL_NO_TESTS`, `OPENSSL_NO_FUZZ`, `OPENSSL_NO_BUILDTEST_CXX`
Do not build or run the tests or do fuzzing.
The last tries to compile all header files with C++ and is done during
CMake parsing, not regular test execution.
- `OPENSSL_NO_ACVP_TESTS`, `OPENSSL_NO_EXTERNAL_TESTS`
When building tests, exclude the ACVP tests, other external tests
listed as submodules.
- `OPENSSL_NO_DOC`
Do not build or install the manual pages.
- `OPENSSL_DO_UPLINK`
Use the Microsoft "uplink/applink" facility. *Note that this is "DO",
not "NO".*

Architecture-specific defines
=============================
- Big number (BN) implementation details:
A BN is represented as an array of integer types, called a limb.
One of the following should be set:
    - `THIRTY_TWO_BIT`
    Limbs are 32 bits, this is default if no option is specified, it works on
    any supported system (unless "wider" limb size is implied in assembly code).
    - `SIXTY_FOUR_BIT_LONG`
    Limbs are 64 bits and sizeof(long) is 8.
    - `SIXTY_FOUR_BIT`
    Limbs are 64 bits, but execution environment is 32-bit (ILP332).
    - `BN_LLONG`
    Limbs are 32 bits, but 64-bit `unsigned long long` is used internally
    in calculations. This is currently the most commonly-used value and
    implies `THIRTY_TWO_BIT`.
- The type used for the RC4 key schedule can be set by picking one of the
following two values. The default is `RC4_INT` which is correct for many
platforms.
    - `RC4_CHAR`
    Use an `unsigned char` in the implementation.
    - `RC4_INT`
    Use an `unsigned int` in the implementation.
- `OPENSSL_NO_ASM`
Do not use assembly language for optimized implementations.
- `OPENSSL_NO_INLINE_ASM`
Compiler does not support inline assembler.
- `OPENSSL_NO_EC_NISTP_64_GCC_128`
Disable support for optimization of some elliptic curves.
The platform must be little-endian, allow misaligned memory references,
support `uint128_t` and the macro `__SIZEOF_INT128__`.  This is true for
`gcc` and `clang` on X86-64 platforms.

Platform details
================
- `INSTALLPREFIX`
The root of the installation tree, defaults to `/usr/local`
- `OPENSSLDIR`
Where data files are installed, defaults to `${PREFIX}/ssl`.
- `OPENSSL_NO_ATEXIT`, `OPENSSL_NO_PINSHARED`
These control the lifetime of the shared libraries.
By default, QuicTLS will use an `atexit` handlr; one some
platforms the handler is run on unload rather than process exit.
By default, the libraries will be pinned to last until process exist.
- `OPENSSL_NO_POSIX_IO`
Do not build on POSIX facilities: file desriptors, directories,
and the like.
- `OPENSSL_NO_STDIO`
Do not use the C standard I/O library. This will also set
`OPENSSL_NO_POSIX_IO`, `OPENSSL_NO_APPS`, and `OPENSSL_NO_TESTS`.
- `OPENSSL_NO_SOCK`, `OPENSSL_NO_UNIX_SOCK`, `OPENSSL_NO_TFO`
Controls if sockets, Unix-domain sockets, and the TCP "fast open"
option, are available.
- `OPENSSL_NO_KTLS`, `OPENSSL_NO_KTLS_RX`, `OPENSSL_NO_KTLS_ZC_TX`
Controls the use of Linx kernel TLS. The last option requires
kernel headers at 5.19.0 or later, or zero-copy sendfile/transmit.
- `OPENSSL_NO_SECURE_MEMORY`
Controls use of a fixed-size "secure" memory area is available.
This is a non-swapped area, surrounded by an unmapped block so that
simple pointer increments will not work as an attack.
- `OPENSSL_NO_WINSTORE`
Allows the `store` facility to use the Windows certificate store.
- `OPENSSL_NO_BUILTIN_OVERFLOW_CHECKING`
Controls if built-in integral overflow-checking is used as used
in the source file `include/openssl/safe_math.h`

Threads
=======
By default, QuicTLS will build on top of using the native platform
threads (Posix or Windows threads). Additional facilities can be
built on top of that.
-`OPENSSL_THREADS_NONE`, `OPENSSL_THREADS_POSIX`, `OPENSSL_THREADS_WINNT`
No thread support, Posix threads, or Windows.
- `OPENSSL_NO_MUTEX_ERRORCHECK`
In debug (non-release) builds, uses `PTHREAD_MUTEX_ERRORCHECK` when creating
POSIX mutexes.
- `OPENSSL_NO_ASYNC`
Do not enable asynchronous operations
- Controlling whether there is a thread pool and a default internal
one:
    - `OPENSSL_NO_THREAD_POOL`
    - `OPENSSL_NO_DEFAULT_THREAD_POOL`

Setting API compatibility
=========================
- `OPENSSL_NO_DEPRECATED`
If set, all symbols defined in the specified release or earlier are
not available. If no release is specified the current/latest release
is used. If not set, then attempts to use a deprecated item will
generate a warning.
The following values can be used; higher releases imply all lower
values.
    - `OPENSSL_NO_DEPRECATED_3_1`
    - `OPENSSL_NO_DEPRECATED_3_0`
    - `OPENSSL_NO_DEPRECATED_1_1_1`
    - `OPENSSL_NO_DEPRECATED_1_1_0`
    - `OPENSSL_NO_DEPRECATED_1_0_2`
    - `OPENSSL_NO_DEPRECATED_1_0_1`
    - `OPENSSL_NO_DEPRECATED_1_0_0`
    - `OPENSSL_NO_DEPRECATED_0_9_8`

Library initialization
======================
Some of these behaviors can be controlled at run-time through
the `OPENSSL_init()` API.
- `OPENSSL_NO_AUTOALGINIT`
Do not load all algorithm implementations.
- `OPENSSL_NO_AUTOERRINIT`
Do not load the error strings.
- `OPENSSL_NO_AUTOLOAD_CONFIG`
Do not load the default configuration file at start-up.

Engines
=======
- `OPENSSL_NO_ENGINE`
Do not build ENGINE support, including the `openssl` app flags.
- `OPENSSL_NO_STATIC_ENGINE`
No ENGINE implementations are compiled into the library. Specific
engines can be removed by specificing a combination of the following:
    - `OPENSSL_NO_AFALGENG`
    - `OPENSSL_NO_CAPIENG`
    - `OPENSSL_NO_DEVCRYPTOENG`
    - `OPENSSL_NO_PADLOCKENG`

Library and command features
============================
Various features can be disabled in the library, and the associated
commands.
- `OPENSSL_NO_CACHED_FETCH`
Do not cache the various "fetch" operations. This will save some
run-time memory but has a performance cost.
- `OPENSSL_NO_CMP`
- `OPENSSL_NO_CMS`
- `OPENSSL_NO_CT`
- `OPENSSL_NO_ERR`
- `OPENSSL_NO_FILENAMES`
Do not include source filenames in errors or other reporting.
- `OPENSSL_NO_HTTP`
Controls if an HTTP client library is included in libcrypto.
Controls if console-based prompts (usually for passwords) are disabled.
If so, then all passwords used by the `openssl` app must be
specified on the commandline.
- `OPENSSL_NO_OCSP`
- `OPENSSL_NO_PSK`
- `OPENSSL_NO_RFC3779`
- `OPENSSL_NO_SSLKEYLOG`, `OPENSSL_NO_SSLKEYLOG_CB`
- `OPENSSL_NO_SCTP`
- `OPENSSL_NO_SRTP`
- `OPENSSL_NO_TS`
- `OPENSSL_NO_UI_CONSOLE`

Cryptographic algorithms
========================
- `OPENSSL_NO_MULTIBLOCK`
Disables interleaving blocks when multiple cryptographic algorithms
are used on the same data. This is an optimization for TLS.
- Many cryptographic algorithms, or families, can be disabled.
When this is done, the equivalent command in the `openssl` app is
also disabled.
    - `OPENSSL_NO_ARGON2`
    - `OPENSSL_NO_ARIA`
    - `OPENSSL_NO_BF`
    - `OPENSSL_NO_BLAKE2`
    - `OPENSSL_NO_CAMELLIA`
    - `OPENSSL_NO_CAST`
    - `OPENSSL_NO_CHACHA`
    - `OPENSSL_NO_CMAC`
    - `OPENSSL_NO_CRMF`
    - `OPENSSL_NO_DSA`
    - `OPENSSL_NO_DES`
    - `OPENSSL_NO_DH`
    - `OPENSSL_NO_EC`
    - `OPENSSL_NO_GOST`
    - `OPENSSL_NO_IDEA`
    - `OPENSSL_NO_MD2`
    - `OPENSSL_NO_MD4`
    - `OPENSSL_NO_MDC2`
    - `OPENSSL_NO_OCB`
    - `OPENSSL_NO_POLY1305`
    - `OPENSSL_NO_RC2`
    - `OPENSSL_NO_RC4`
    - `OPENSSL_NO_RC5`
    - `OPENSSL_NO_RMD160`
    - `OPENSSL_NO_RSA`
    - `OPENSSL_NO_SCRYPT`
    - `OPENSSL_NO_SEED`
    - `OPENSSL_NO_SHA1`
    - `OPENSSL_NO_SIPHASH`
    - `OPENSSL_NO_SIV`
    - `OPENSSL_NO_SM2`
    - `OPENSSL_NO_SM2_PRECOMP`
    - `OPENSSL_NO_SM3`
    - `OPENSSL_NO_SM4`
    - `OPENSSL_NO_WHIRLPOOL`

Compression
===========
- `OPENSSL_NO_COMP`
Set to disable all compression.
Invidual algorithms can be statically linked against or dynamically
loaded:
    - `OPENSSL_NO_BROTLI`, `OPENSSL_NO_BROTLI_DYNAMIC`
    - `OPENSSL_NO_ZLIB`, `OPENSSL_NO_ZLIB_DYNAMIC`
    - `OPENSSL_NO_ZSTD`, `OPENSSL_NO_ZSTD_DYNAMIC`

(D)TLS versions
===============
- `OPENSSL_NO_WEAK_SSL_CIPHERS`
Basically disables triple-DES in CBC mode, and RC4.
- `OPENSSL_NO_DTLS`
Disables all support for DTLS. Individual versions, and the dispatch
method API for them, can be disabled by the following:
    - `OPENSSL_NO_DTLS1`, `OPENSSL_NO_DTLS1_METHOD`
    - `OPENSSL_NO_DTLS1_2`, `OPENSSL_NO_DTLS1_2_METHOD`
- `OPENSSL_NO_TLS`
Disables all support for SSL/TLS. Individual versions, and the dispatch
method API for them, can be disabled by the following:
    - `OPENSSL_NO_SSL3`, `OPENSSL_NO_SSL3_METHOD`
    - `OPENSSL_NO_TLS1_1`, `OPENSSL_NO_TLS1_1_METHOD`
    - `OPENSSL_NO_TLS1_2`, `OPENSSL_NO_TLS1_2_METHOD`
    - `OPENSSL_NO_TLS1_3`, `OPENSSL_NO_TLS1_METHOD`
