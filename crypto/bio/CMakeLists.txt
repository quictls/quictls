# Base library
set(SOURCE
    bio_addr.c bio_cb.c bio_dump.c bio_err.c bio_lib.c bio_meth.c
    bio_print.c bio_sock.c bio_sock2.c ossl_core_bio.c)

# Source / sink implementations
list(APPEND SOURCE
    bss_acpt.c bss_bio.c bss_conn.c bss_core.c bss_dgram.c bss_dgram_pair.c
    bss_fd.c bss_file.c bss_log.c bss_mem.c bss_null.c bss_sock.c)

# Filters
list(APPEND SOURCE
    bf_buff.c bf_lbuf.c bf_null.c bf_prefix.c bf_readbuff.c)
target_sources(crypto PRIVATE ${SOURCE})
