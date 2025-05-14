set(SOURCE
    property_string.c property_parse.c property_query.c property.c
    defn_cache.c property_err.c
    )
target_sources(crypto PRIVATE ${SOURCE})
