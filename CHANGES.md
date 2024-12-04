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
- Based on OpenSSL 3.3

- Remove support for some old configuration options:
  - unit-test as there was only one, so not worth the complication
  - fips, no-fips since we do not build a FIPS-validated container
  - ecdh, it was a no-op
  - no-dgram is now implied by no-sock (no longer can turn off just UDP)

- Remove support for EGD random source.

- Made the `ERR_STACK` datatype opaque.

- The undocumented function `X509_OBJECT_up_ref_count` has been
made private.

- Removed some functions deprecated in the OpenSSL 1.1.0 release:
`SRP_VBASE_get_by_user`, `ENGINE_setup_bsd_cryptodev`,
`PKCS12_get_attr`, and `SSL_set_debug`.

- Removed most of the deprecated functions from OpenSSL 0.9.8, but keep
`BN_is_prime_fasttest`, `CRYPTO_mem_ctrl`, `DH_generate_parameters`, and
`RSA_generate_key` for compatibility with outside applications.

- Removed support for some old platforms:
  - Removed support for old HPE platforms: NonStop and Tandem
  - Removed DJGPP support.
  - Removed WinCE support.
  - Removed IRIX support.
  - Removed `I386_only` support.
  - OSF/1, True64, and Ultrix support.

- Simplified `util/shlib_wrap`; if your shell doesn't do "$@" properly
when there are no arguments, please look at an earlier version.
