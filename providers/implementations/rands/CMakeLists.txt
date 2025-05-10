target_sources(defprov PRIVATE 
    drbg.c test_rng.c drbg_ctr.c drbg_hash.c drbg_hmac.c crngt.c seed_src.c
    )

add_subdirectory(seeding)
