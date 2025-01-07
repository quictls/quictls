set(SOURCE
    crmf_asn.c crmf_err.c crmf_lib.c crmf_pbm.c
    )
target_sources(crypto PRIVATE ${SOURCE})
