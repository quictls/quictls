set(SOURCE
    rec_layer_s3.c rec_layer_d1.c
    )
target_sources(ssl PRIVATE ${SOURCE})

add_subdirectory(methods)
