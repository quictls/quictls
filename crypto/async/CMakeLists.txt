set(SOURCE
    async.c async_wait.c async_err.c arch/async_posix.c arch/async_win.c
    arch/async_null.c
    )
target_sources(crypto PRIVATE ${SOURCE})
