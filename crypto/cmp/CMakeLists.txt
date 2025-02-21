set(SOURCE
    cmp_asn.c cmp_ctx.c cmp_err.c cmp_util.c cmp_status.c cmp_hdr.c
    cmp_protect.c cmp_msg.c cmp_vfy.c cmp_server.c cmp_client.c cmp_genm.c
    )

if (NOT OPENSSL_NO_HTTP)
    list(APPEND SOURCE cmp_http.c)
endif ()
target_sources(crypto PRIVATE ${SOURCE})
