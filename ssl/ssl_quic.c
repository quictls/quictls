/*
 * Copyright 2019-2021 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include "ssl_local.h"
#include <internal/cryptlib.h>
#include <internal/refcount.h>

int SSL_set_quic_transport_params(SSL *ssl, const uint8_t *params,
                                  size_t params_len)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return 0;

    uint8_t *tmp;

    if (params == NULL || params_len == 0) {
        tmp = NULL;
        params_len = 0;
    } else {
        tmp = OPENSSL_memdup(params, params_len);
        if (tmp == NULL)
            return 0;
    }

    OPENSSL_free(sc->ext.quic_transport_params);
    sc->ext.quic_transport_params = tmp;
    sc->ext.quic_transport_params_len = params_len;
    return 1;
}

void SSL_get_peer_quic_transport_params(const SSL *ssl,
                                        const uint8_t **out_params,
                                        size_t *out_params_len)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return;

    if (sc->ext.peer_quic_transport_params_len) {
        *out_params = sc->ext.peer_quic_transport_params;
        *out_params_len = sc->ext.peer_quic_transport_params_len;
    } else {
        *out_params = sc->ext.peer_quic_transport_params_draft;
        *out_params_len = sc->ext.peer_quic_transport_params_draft_len;
    }
}

/* Returns the negotiated version, or -1 on error */
int SSL_get_peer_quic_transport_version(const SSL *ssl)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return -1;
    if (sc->ext.peer_quic_transport_params_len != 0
            && sc->ext.peer_quic_transport_params_draft_len != 0)
        return -1;
    if (sc->ext.peer_quic_transport_params_len != 0)
        return TLSEXT_TYPE_quic_transport_parameters;
    if (sc->ext.peer_quic_transport_params_draft_len != 0)
        return TLSEXT_TYPE_quic_transport_parameters_draft;

    return -1;
}

void SSL_set_quic_use_legacy_codepoint(SSL *ssl, int use_legacy)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return;
    if (use_legacy)
        sc->quic_transport_version = TLSEXT_TYPE_quic_transport_parameters_draft;
    else
        sc->quic_transport_version = TLSEXT_TYPE_quic_transport_parameters;
}

void SSL_set_quic_transport_version(SSL *ssl, int version)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return;
    sc->quic_transport_version = version;
}

int SSL_get_quic_transport_version(const SSL *ssl)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return -1;
    return sc->quic_transport_version;
}

size_t SSL_quic_max_handshake_flight_len(const SSL *ssl, OSSL_ENCRYPTION_LEVEL level)
{
    /*
     * Limits flights to 16K by default when there are no large
     * (certificate-carrying) messages.
     */
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return -1;
    static const size_t DEFAULT_FLIGHT_LIMIT = 16384;

    switch (level) {
    case ssl_encryption_initial:
        return DEFAULT_FLIGHT_LIMIT;
    case ssl_encryption_early_data:
        /* QUIC does not send EndOfEarlyData. */
        return 0;
    case ssl_encryption_handshake:
        if (sc->server) {
            /*
             * Servers may receive Certificate message if configured to request
             * client certificates.
             */
            if ((sc->verify_mode & SSL_VERIFY_PEER)
                    && sc->max_cert_list > DEFAULT_FLIGHT_LIMIT)
                return sc->max_cert_list;
        } else {
            /*
             * Clients may receive both Certificate message and a CertificateRequest
             * message.
             */
            if (2*sc->max_cert_list > DEFAULT_FLIGHT_LIMIT)
                return 2 * sc->max_cert_list;
        }
        return DEFAULT_FLIGHT_LIMIT;
    case ssl_encryption_application:
        return DEFAULT_FLIGHT_LIMIT;
    }

    return 0;
}

OSSL_ENCRYPTION_LEVEL SSL_quic_read_level(const SSL *ssl)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return -1;
    return sc->quic_read_level;
}

OSSL_ENCRYPTION_LEVEL SSL_quic_write_level(const SSL *ssl)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return -1;
    return sc->quic_write_level;
}

int SSL_provide_quic_data(SSL *ssl, OSSL_ENCRYPTION_LEVEL level,
                          const uint8_t *data, size_t len)
{
    if (!SSL_is_quic(ssl)) {
        ERR_raise(ERR_LIB_SSL, ERR_R_SHOULD_NOT_HAVE_BEEN_CALLED);
        return 0;
    }
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return -1;

    /* Level can be different than the current read, but not less */
    if (level < sc->quic_read_level
            || (sc->quic_input_data_tail != NULL && level < sc->quic_input_data_tail->level)
            || level < sc->quic_latest_level_received) {
        ERR_raise(ERR_LIB_SSL, SSL_R_WRONG_ENCRYPTION_LEVEL_RECEIVED);
        return 0;
    }

    if (len == 0)
        return 1;

    /* A TLS message must not cross an encryption level boundary */
    size_t fragment_length = ssl->quic_buf != NULL ? ssl->quic_buf->length : 0;
    if (fragment_length != 0 && level != ssl->quic_latest_level_received) {
        ERR_raise(ERR_LIB_SSL, SSL_R_WRONG_ENCRYPTION_LEVEL_RECEIVED);
        return 0;
    }
    sc->quic_latest_level_received = level;

    if (fragment_length != 0) {
        /*
         * We have a partial record, copy the data into the buffer, and
         * parse records from it.
         */
        if (!BUF_MEM_grow(ssl->quic_buf, fragment_length + len)) {
            ERR_raise(ERR_LIB_SSL, ERR_R_INTERNAL_ERROR);
            return 0;
        }
        memcpy(ssl->quic_buf->data + fragment_length, data, len);
        data = (const uint8_t *)ssl->quic_buf->data;
        len = ssl->quic_buf->length;
    }

    /* Split on handshake message boundaries */
    while (len > SSL3_HM_HEADER_LENGTH) {
        QUIC_DATA *qd;
        size_t l;
        const uint8_t *p = data + 1;

        n2l3(p, l);
        l += SSL3_HM_HEADER_LENGTH;
        /* Don't allocate a QUIC_DATA if we don't have a full record */
        if (l > len)
            break;

        qd = OPENSSL_zalloc(sizeof(*qd) + l);
        if (qd == NULL) {
            ERR_raise(ERR_LIB_SSL, ERR_R_INTERNAL_ERROR);
            return 0;
        }

        qd->next = NULL;
        qd->length = l;
        qd->level = level;
        memcpy((void *)(qd + 1), data, l);

        if (sc->quic_input_data_tail != NULL)
            sc->quic_input_data_tail->next = qd;
        else
            sc->quic_input_data_head = qd;
        sc->quic_input_data_tail = qd;

        /* Remove the now-consumed data. */
        data += l;
        len -= l;
    }

    /* If we have any unread data, we need to save it. */
    if (len > 0) {
        if (ssl->quic_buf != NULL) {
            if (data == (const uint8_t *)ssl->quic_buf->data) {
                /* Already in the buffer, no need to do anything.. */
                return 1;
            }
        } else {
            if ((ssl->quic_buf = BUF_MEM_new()) == NULL) {
                ERR_raise(ERR_LIB_SSL, ERR_R_INTERNAL_ERROR);
                return 0;
            }
        }
        /*
         * Note: 'data' might be in this buffer, but if that's the case,
         * we're going to be shrinking the buffer, so the pointer will not be
         * invalidated.  We do need to use memmove() and not memcpy(), though.
         */
        if (!BUF_MEM_grow(ssl->quic_buf, len)) {
            ERR_raise(ERR_LIB_SSL, ERR_R_INTERNAL_ERROR);
            return 0;
        }
        memmove(ssl->quic_buf->data, data, len);
    } else {
        if (ssl->quic_buf != NULL) {
            ssl->quic_buf->length = 0;
        }
    }

    return 1;
}

int SSL_CTX_set_quic_method(SSL_CTX *ctx, const SSL_QUIC_METHOD *quic_method)
{
    if (ctx->method->version != TLS_ANY_VERSION)
        return 0;
    ctx->quic_method = quic_method;
    ctx->options &= ~SSL_OP_ENABLE_MIDDLEBOX_COMPAT;
    return 1;
}

int SSL_set_quic_method(SSL *ssl, const SSL_QUIC_METHOD *quic_method)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return -1;
    if (ssl->method->version != TLS_ANY_VERSION)
        return 0;
    sc->quic_method = quic_method;
    sc->options &= ~SSL_OP_ENABLE_MIDDLEBOX_COMPAT;
    return 1;
}

int quic_set_encryption_secrets(SSL *ssl, OSSL_ENCRYPTION_LEVEL level)
{
    uint8_t *c2s_secret = NULL;
    uint8_t *s2c_secret = NULL;
    size_t len;
    const EVP_MD *md;
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);

    if (!SSL_is_quic(ssl))
        return 1;

    if (sc == NULL)
        return -1;

    /* secrets from the POV of the client */
    switch (level) {
    case ssl_encryption_early_data:
        c2s_secret = sc->client_early_traffic_secret;
        break;
    case ssl_encryption_handshake:
        c2s_secret = sc->client_hand_traffic_secret;
        s2c_secret = sc->server_hand_traffic_secret;
        break;
    case ssl_encryption_application:
        c2s_secret = sc->client_app_traffic_secret;
        s2c_secret = sc->server_app_traffic_secret;
        break;
    default:
        return 1;
    }

    if (level == ssl_encryption_early_data) {
        const SSL_CIPHER *c = SSL_SESSION_get0_cipher(sc->session);
        if (sc->early_data_state == SSL_EARLY_DATA_CONNECTING
                && sc->max_early_data > 0
                && sc->session->ext.max_early_data == 0) {
            if (!ossl_assert(sc->psksession != NULL
                    && sc->max_early_data ==
                       sc->psksession->ext.max_early_data)) {
                SSLfatal(sc, SSL_AD_INTERNAL_ERROR, ERR_R_INTERNAL_ERROR);
                return 0;
            }
            c = SSL_SESSION_get0_cipher(sc->psksession);
        }

        if (c == NULL) {
            SSLfatal(sc, SSL_AD_INTERNAL_ERROR, ERR_R_INTERNAL_ERROR);
            return 0;
        }

        md = ssl_md(ssl->ctx, c->algorithm2);
    } else {
        md = ssl_handshake_md(sc);
        if (md == NULL) {
            /* May not have selected cipher, yet */
            const SSL_CIPHER *c = NULL;

            /*
             * It probably doesn't make sense to use an (external) PSK session,
             * but in theory some kinds of external session caches could be
             * implemented using it, so allow psksession to be used as well as
             * the regular session.
             */
            if (sc->session != NULL)
                c = SSL_SESSION_get0_cipher(sc->session);
            else if (sc->psksession != NULL)
                c = SSL_SESSION_get0_cipher(sc->psksession);

            if (c != NULL)
                md = SSL_CIPHER_get_handshake_digest(c);
        }
    }

    if ((len = EVP_MD_size(md)) <= 0) {
        SSLfatal(sc, SSL_AD_INTERNAL_ERROR, ERR_R_INTERNAL_ERROR);
        return 0;
    }

    if (sc->server) {
        if (!sc->quic_method->set_encryption_secrets(ssl, level, c2s_secret,
                                                      s2c_secret, len)) {
            SSLfatal(sc, SSL_AD_INTERNAL_ERROR, ERR_R_INTERNAL_ERROR);
            return 0;
        }
    } else {
        if (!sc->quic_method->set_encryption_secrets(ssl, level, s2c_secret,
                                                      c2s_secret, len)) {
            SSLfatal(sc, SSL_AD_INTERNAL_ERROR, ERR_R_INTERNAL_ERROR);
            return 0;
        }
    }

    return 1;
}

int SSL_process_quic_post_handshake(SSL *ssl)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return 0;

    int ret;

    if (SSL_in_init(ssl) || !SSL_is_quic(ssl)) {
        ERR_raise(ERR_LIB_SSL, ERR_R_SHOULD_NOT_HAVE_BEEN_CALLED);
        return 0;
    }

    /* if there is no data, return success as BoringSSL */
    while (sc->quic_input_data_head != NULL) {
        /*
         * This is always safe (we are sure to be at a record boundary) because
         * SSL_read()/SSL_write() are never used for QUIC connections -- the
         * application data is handled at the QUIC layer instead.
         */
        ossl_statem_set_in_init(sc, 1);
        ret = sc->handshake_func(ssl);
        ossl_statem_set_in_init(sc, 0);

        if (ret <= 0)
            return 0;
    }
    return 1;
}

void SSL_set_quic_early_data_enabled(SSL *ssl, int enabled)
{
    SSL_CONNECTION *sc = SSL_CONNECTION_FROM_SSL(ssl);
    if (sc == NULL)
        return;

    if (!SSL_is_quic(ssl) || !SSL_in_before(ssl))
        return;

    if (!enabled) {
      sc->early_data_state = SSL_EARLY_DATA_NONE;
      return;
    }

    if (sc->server) {
        sc->early_data_state = SSL_EARLY_DATA_ACCEPTING;
        return;
    }

    if ((sc->session == NULL || sc->session->ext.max_early_data == 0)
            && sc->psk_use_session_cb == NULL)
        return;

    sc->early_data_state = SSL_EARLY_DATA_CONNECTING;
}
