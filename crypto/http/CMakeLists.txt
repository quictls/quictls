set(SOURCE
    http_client.c http_err.c http_lib.c
    )
target_sources(crypto PRIVATE ${SOURCE})
