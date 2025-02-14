set(SOURCE
    ocsp_asn.c ocsp_ext.c ocsp_http.c ocsp_lib.c ocsp_cl.c ocsp_srv.c
    ocsp_prn.c ocsp_vfy.c ocsp_err.c v3_ocsp.c
    )
target_sources(crypto PRIVATE ${SOURCE})
