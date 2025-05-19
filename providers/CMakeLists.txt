# Provider common library
add_library(common)
target_include_directories(common PUBLIC
    ../crypto ../include ${CMAKE_BINARY_DIR}/include)
target_compile_options(common PRIVATE -fPIC)
add_dependencies(common headers)
target_sources(common PRIVATE ../ssl/record/methods/tls_pad.c)

# Default provider
add_library(defprov)
target_include_directories(defprov PUBLIC
    ../crypto ../include ${CMAKE_BINARY_DIR}/include)
target_compile_options(defprov PRIVATE -fPIC)
target_compile_definitions(defprov PRIVATE OPENSSL_CPUID_OBJ)
target_compile_definitions(defprov PRIVATE AES_ASM)
add_dependencies(defprov headers)
target_sources(defprov PRIVATE ../ssl/record/methods/ssl3_cbc.c)
target_link_libraries(defprov PRIVATE common)


# Built-in providers
target_sources(crypto PRIVATE
    defltprov.c baseprov.c nullprov.c prov_running.c
    )

add_subdirectory(common)
add_subdirectory(implementations)
