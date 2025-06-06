target_sources(defprov PRIVATE file_store.c file_store_any2obj.c)
if (WIN32 AND NOT OPENSSL_NO_WINSTORE)
    target_sources(defprov PRIVATE winstore_store.c)
endif ()
