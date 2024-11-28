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

- Remove support for EGD random source.

- Made the ERR_STACK datatype opaque.

- Removed support for some old platforms:
  - Removed support for old HPE platforms: NonStop and Tandem
  - Removed DJGPP support.
  - Removed WinCE support.
  - Removed IRIX support.
  - Removed `I386_only` support.
