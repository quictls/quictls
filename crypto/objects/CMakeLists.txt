set(SOURCE
    o_names.c obj_dat.c obj_lib.c obj_err.c obj_xref.c
    )
target_sources(crypto PRIVATE ${SOURCE})
