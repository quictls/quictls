add_library(apps)
target_include_directories(apps PUBLIC ${CMAKE_BINARY_DIR}/include)
add_dependencies(apps headers)

set(SOURCE)
if (WIN32)
    list(APPEND SOURCE win32_init.c)
endif ()

list(APPEND SOURCE
    apps.c apps_ui.c log.c opt.c fmt.c s_cb.c s_socket.c app_rand.c
    columns.c app_params.c names.c app_provider.c app_x509.c http_server.c
    engine.c engine_loader.c app_libctx.c apps_opt_printf.c
    )

target_sources(apps PRIVATE ${SOURCE})
