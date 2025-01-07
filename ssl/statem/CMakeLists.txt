set(SOURCE
    extensions.c extensions_clnt.c extensions_cust.c extensions_srvr.c
    statem.c statem_clnt.c statem_dtls.c statem_lib.c statem_srvr.c
    )

target_sources(ssl PRIVATE ${SOURCE})
