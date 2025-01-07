macro (hpux)
    base()
    add_definitions(_XOPEN_SOURCE _XOPEN_SOURCE_EXTENDED
        _HPUX_ALT_XOPEN_SOCKET_API)
    target_link_libraries(crypto -lpthreads)
endmacro ()
