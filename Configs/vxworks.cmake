## VxWorks for various targets
macro(vxworks_ppc60x)
    base()
    target_compile_options(crypto -O2 -Wall -fstrength-reduce
        -mrtp -mhard-float -mstrict-align -fnomplicit-fp
        -fno-builtin -fno-strict-aliasing)
    add_definitions(_REENTRANT PPC32_fp60x CPU=PPC32 _DTOOL_FAMILY=gnu TOOL=gnu)
    add_include_directories($(WIND_BASE)/target/usr/h
        $(WIND_BASE)/target/usr/h/wrn/coreip)
    add_link_options(-L $(WIND_BASE)/target/usr/lib/ppc/PPC32/common
        -Wl,--defsym,__wrs_rtp_base=0xe0000000)
endmacro ()

macro(vxworks_ppcgen)
    base()
    target_compile_options(crypto -O1 -Wall -mrtp -msoft-float -mstrict-align
        -fno-builtin -fno-strict-aliasing)
    add_definitions(_REENTRANT PPC32 CPU=PPC32 TOOL_FAMILY=gnu TOOL=gnu)
    add_include_drectories($(WIND_BASE)/target/usr/h
        $(WIND_BASE)/target/usr/h/wrn/coreip)
    add_link_options(-L $(WIND_BASE)/target/usr/lib/ppc/PPC32/sfcommon
        -Wl,--defsym,__wrs_rtp_base=0xe0000000)
endmacro ()

macro(vxworks_ppc405)
    base()
    target_compile_options(crypto -g -msoft-float -mlongcall)
    add_definitions(_REENTRANT PPC32 CPU=PPC405 TOOL_FAMILY=gnu TOOL=gnu)
    add_include_directories($(WIND_BASE)/target/h)
    add_link_options(-r)
endmacro ()

macro(vxworks_ppc750)
    base()
    target_compile_options(crypto -ansi -fvolatile -Wall $(DEBUG_FLAG) -nostdinc
        -fno-builtin -fno-for-scope -fsigned-char -msoft-float -mlongcall)
    add_definitions(PPC750 _REENTRANT CPU=PPC604)
    add_include_directories($(WIND_BASE)/target/h)
    add_link_options(-r)
endmacro ()

macro(vxworks_ppc750_debug)
    base()
    target_compile_options(crypto -ansi -fvolatile -Wall -g -nostdinc
        -fno-builtin -fno-for-scope -fsigned-char -msoft-float -mlongcall)
    add_definitions(PPC750 _REENTRANT CPU=PPC604 PEDANTIC DEBUG)
    add_include_directories($(WIND_BASE)/target/h)
    add_link_options(-r)
endmacro ()

macro(vxworks_ppc860)
    base()
    target_compile_options(crypto -nostdinc -msoft-float)
    add_definitions(CPU=PPC860 NO_STRINGS_H)
    add_include_directories($(WIND_BASE)/target/h)
    add_link_options(-r)
endmacro ()

macro(vxworks_simlinux)
    base()
    target_compile_options(crypto
        -B$(WIND_BASE)/host/$(WIND_HOST_TYPE)/lib/gcc-lib/
        -fno-builtin -fno-defer-pop)
    add_definitions(
        _VSB_CONFIG_FILE=$(WIND_BASE)/target/lib/h/config/vsbConfig.h
        CPU=SIMLINUX NO_STRINGS_H TOOL_FAMILY=gnu TOOL=gnu)
    add_include_directories($(WIND_BASE)/target/h
        $(WIND_BASE)/target/h/wrn/coreip)
    add_link_options(-r)
endmacro ()

macro(vxworks_mips)
    base()
    target_compile_options(crypto -O -G 0 -mrtp -mips2
        -B$(WIND_BASE)/host/$(WIND_HOST_TYPE)/lib/gcc-lib/ -msoft-float
        -mno-branch-likely -fno-builtin -fno-defer-pop)
    add_definitions(
        _VSB_CONFIG_FILE=$(WIND_BASE)/target/lib/h/config/vsbConfig.h
        CPU=MIPS32 NO_STRINGS_H TOOL_FAMILY=gnu -DTOOL=gnu D_REENTRANT)
    add_include_directories($(WIND_BASE)/target/h
        $(WIND_BASE)/target/h/wrn/coreip)
    add_link_options(-L $(WIND_BASE)/target/usr/lib/mips/MIPSI32/sfcommon)
    target_link_libraries(crypto -Wl,--defsym,__wrs_rtp_base=0xe0000000)
    set(OPENSSL_THREADS_POSIX 1)
    set(PERLASM_SCHEME o32)
endmacro ()
