QuicTLS CHANGES
===============

This is a high-level summary of the most important changes.
For a full list of changes, see the [git commit log][log] and
pick the appropriate release branch.

  [log]: https://github.com/quictls/quictls/commits/

*NOTE:*
The FIPS provider in QuicTLS is *not* the same code as the validated
OpenSSL FIPS provider.

QuicTLS Releases
----------------
None yet :)

Currrent Changes
----------------
- Based on OpenSSL 3.3, with some code from OpenSSL 3.4 cherry-picked.

- The source now requires C99, and various simplifications were made
as a result, such as using the standard sized types, the `inline`
keyword, named initializers, etc.

- Cherry-picked changes to assembly generation to support running code
in execute-only mode and with indirect branch tracking on modern Intel
hardware.

- Cherry-picked no_cache provider behavior change to fix pkcs11-provider,
which initially reports "no algorithms" and expects to be queried again
when the supported algorithms can be determined from the HSM token.

- Simplified `util/shlib_wrap`; if your shell doesn't do "$@" properly
when there are no arguments, please look at an earlier version of
this script.

- Move the two apps, CA.pl and tsget, that were written in Perl, to a
separate directory. Perl is optional on intalled systems.

- No longer ship `fipskey.h`; have to enter the key on the commandline
if installing the OpenSSL FIPS module.

- Almost all uses of the Perl templating package other than the build
system were replaced with short custom scripts. Perl is still required
to configure and set up the build system.

- Removed the `-nbio_test` flag from the client and server apps, and
removed the undocumented and otherwise unused "test non-blocking IO" BIO.

- Several API changes were made:
  - The undocumented function `X509_OBJECT_up_ref_count` has been
made private.
  - Remove some depecrated (3.0) undocumented functions that were just
aliases for others: `BUF_strdup`, `BUF_strndup`, `BUF_memdup`,
`BUF_strlcpy`, `BUF_strlcat`, and `BUF_strnlen`.
  - Removed some functions deprecated in the OpenSSL 1.1.0 release:
`ENGINE_setup_bsd_cryptodev`, `PKCS12_get_attr`, and `SSL_set_debug`.
  - Removed most of the deprecated functions from OpenSSL 0.9.8, but kept
`BN_is_prime_fasttest`, `CRYPTO_mem_ctrl`, `DH_generate_parameters`, and
`RSA_generate_key` for compatibility with outside applications.
  - Made the `ERR_STACK` datatype opaque.
  - Support for the undocumented and outdated "Strong Extranet ID"
certificate extension and the "Netscape Certificate Sequence"
data format have been removed.
  - Remove most of the ERRxxx() macros; engines still use them since their
library number is dynamic not static.
  - The unused and undocumented `BIO_f_linebuffer`, `BIO_f_reliable`, and
`BIO_s_log` now return NULL.

- Header files were reorganized:
  - The redundant `#pragma once` and old-style header guards were removed.
  - The `apps/include` directory was moved to `include/apps`, the header files
in `test` were moved to a new `include/test` directory, and the two
`include/prov` direcotires in `providers` were merged into a new
`include/providers` directory.
  - `#include` statements were modified to use angle brackets
  - The header file `opensslv.h` has been merged into `configuration.h`
The old file currently exists for compatibility with cmake.

- Imported the sslkeylog build-time configuration option from OpenSSL. If
enabled, all secrets are logged to the file specified in the `SSLKEYLOGFILE`
environment variable. *Do not enable or use this in production.*
Added an additional `sslkeylog-cb` configuration option that makes
the application-specified logging callback work.
Ported from OpenSSL PR#25297.

- Remove support for some old configuration options, `configuration.h`
has hardwired `#define` values as appropriate.
  - no-unit-test as there was only one, so not worth the complication
  - no-fips since we do not build a FIPS-validated container
  - no-ecdh, it was a no-op
  - no-ecx and no-ecdsa were merged into no-ec.
  - `no-tls1_3,` so TLS 1.3 cannot be disabled.
  - no-dgram and no-http are now implied by no-sock
  - no-nextprotoneg (the default) code has been removed; it was
replaced by the ALPN extension, IETF RFC 7301, in 2014.
  - no-srp (the default) code has been removed
  - no-crypto-mdebug and the code has been removed; better tools exist.
  - Remove support for EGD random source.
  - no-trace (the default) code has been removed. This was not uniformly
used. It was also a security concern as it was not documented that it would
log key material.
  - The `RDRAND` engine and the no-rdrand configuration option have been removed
as they were replaced by the built-in RAND changes.
  - Removed `I386_only`

- Removed support for some old or unsupported platforms:
  - Apollo.
  - Borland/Embarcadero compilers
  - C64x+ (a digital signal processor from TI)
  - DJGPP
  - HP-PARISC (including MPE/ix)
  - IRIX
  - Itanium (IA-64)
  - NonStop (HPE)
  - SCO platforms.
  - Tandem (HPE)
  - uClinux
  - Ultrix, OSF/1, and True64
  - UWIN
  - VMS, OpenVMS, etc.
  - VxWorks
  - WinCE

- Removed support for SCTP.
