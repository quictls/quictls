target_sources(defprov PRIVATE 
    rand_unix.c rand_win.c rand_tsc.c)
if (NOT OPENSSL_NO_ASM AND ${ARCH} MATCHES ".*aarch64")
    target_sources(defprov PRIVATE rand_cpu_arm64.c)
else ()
    target_sources(defprov PRIVATE rand_cpu_x86.c)
endif ()
