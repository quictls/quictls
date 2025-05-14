target_sources(common PRIVATE provider_err.c provider_ctx.c)
add_subdirectory(der)

target_sources(defprov PRIVATE
    provider_util.c capabilities.c bio_prov.c digest_to_nid.c
    securitycheck.c provider_seeding.c securitycheck_default.c
    der/der_rsa_sig.c
    )
