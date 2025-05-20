# Macro to define a provider library

macro (provider_library library)
    add_library(${library})
    add_dependencies(${library} headers)
    target_include_directories(${library} PUBLIC
        ../crypto ../include ${CMAKE_BINARY_DIR}/include)
    target_compile_definitions(${library} PRIVATE PROVIDER_DEFINITIONS)
    target_compile_options(${library} PRIVATE -fPIC)
endmacro ()

# Provider common library
provider_library(common)
target_sources(common PRIVATE ../ssl/record/methods/tls_pad.c)

# Default provider
provider_library(defprov)
target_sources(defprov PRIVATE ../ssl/record/methods/ssl3_cbc.c)
target_link_libraries(defprov PRIVATE common)


# Built-in providers
target_sources(crypto PRIVATE
    defltprov.c baseprov.c nullprov.c prov_running.c
    )

add_subdirectory(common)
add_subdirectory(implementations)
