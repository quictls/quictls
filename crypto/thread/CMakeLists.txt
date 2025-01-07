set(THREADS_ARCH
    arch.c arch/thread_win.c
    arch/thread_posix.c arch/thread_none.c)

if (NOT OPENSSL_NO_THREAD_POOL)
    set(SOURCE api.c internal.c ${THREADS_ARCH})
else ()
    set(SOURCE thread/apiapi.c)
endif ()

target_sources(crypto PRIVATE ${SOURCE})
