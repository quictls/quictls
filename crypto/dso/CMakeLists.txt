set(SOURCE
    dso_dlfcn.c dso_err.c dso_lib.c dso_openssl.c dso_win32.c
    )
target_sources(crypto PRIVATE ${SOURCE})
