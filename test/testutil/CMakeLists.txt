set(SOURCE)
if (WIN32)
    if (OPENSSL_DO_UPLINK)
        list(APPEND SOURCE ../ms/applink.c)
    endif ()
    # More about UTF8, codepage, argv; not initialization
    list(APPEND SOURCE ../apps/lib/win32_init.c)
endif ()

list(APPEND SOURCE
    basic_output.c output.c driver.c tests.c cb.c stanza.c format_output.c
    load.c fake_random.c test_cleanup.c main.c testutil_init.c options.c
    test_options.c provider.c apps_shims.c random.c ../../apps/lib/opt.c
    # These were separate files in "test/helper"  and in "test/" Why?
    cmp_testlib.c handshake.c pkcs12.c predefined_dhparams.c ssl_test_ctx.c
    ssltestlib.c fake_rsaprov.c simpledynamic.c
    )

add_library(testutil STATIC)
target_include_directories(testutil PUBLIC ${CMAKE_BINARY_DIR}/include)
add_dependencies(testutil headers)
target_sources(testutil PRIVATE ${SOURCE})
target_link_libraries(testutil crypto-static)

add_library(testutil-dyn SHARED)
target_include_directories(testutil-dyn PUBLIC ${CMAKE_BINARY_DIR}/include)
add_dependencies(testutil-dyn headers)
target_sources(testutil-dyn PRIVATE ${SOURCE})


