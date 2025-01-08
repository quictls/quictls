# QUIC

In addition to an OpenSSL-compatible libcrypto implementation (for cryptographic primitives),
this library provides what is colloquially known as the &ldquo;BoringSSL QUIC API&rdquo;. This can be
used by QUIC transport implementations for the TLS handshake - solving the cryptographic portion of QUIC while
leaving the transport implementation external.

To be clear: the libcrypto API referred to here is the set of cryptographic primitives in OpenSSL's libcrypto and
not the QUIC transport feature (of OpenSSL 3.x). QUIC implementations that only use cryptographic primitives from libcrypto typically
require a separate SSL/TLS helper library.

We list several QUIC implementations that are known to use the BoringSSL QUIC or libcrypto API; - it should
be fairly straightforward to consume this library as an implementation of the BoringSSL QUIC/libcrypto APIs.


Reference: https://github.com/mmmarcos/awesome-quic

## Known QUIC Implementations

These projects use the BoringSSL QUIC API or the OpenSSL libcrypto API:

|Project|(Current) TLS Dependency|
|--------|--------|
|[microsoft/msquic](https://github.com/microsoft/msquic)| [quictls/openssl](https://github.com/quictls/openssl) |
|[litespeedtech/lsquic](https://github.com/litespeedtech/lsquic)|[BoringSSL](https://github.com/google/boringssl)|
|[ngtcp2/ngtcp2](https://github.com/ngtcp2/ngtcp2)|[quictls/openssl](https://github.com/quictls/openssl)|
|[alibaba/xquic](https://github.com/alibaba/xquic)|[BoringSSL](https://github.com/google/boringssl)|
|[private-octopus/picoquic](https://github.com/private-octopus/picoquic)| libcrypto-only,  [picotls](https://github.com/h2o/picotls) for TLS|
|[facebook/mvfst](https://github.com/facebook/mvfst) |libcrypto-only,  [fizz](https://github.com/facebookincubator/fizz) for TLS|
