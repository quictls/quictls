macro (base_windows)
    base()
    set(OPENSSL_NO_STATIC_ENGINE 1)

#?       lib_defines      =>
#?           sub {
#?               my @defs = ();
#?               unless ($disabled{"zlib-dynamic"}) {
#?                   my $zlib = $withargs{zlib_lib} // "ZLIB1";
#?                   push @defs, 'LIBZ=' . (quotify("perl", $zlib))[0];
#?               }
#?               return [ @defs ];
#?           },
#?       ex_libs         =>
#?           sub {
#?               my @libs = ();
#?               unless ($disabled{zlib}) {
#?                   if (defined($disabled{"zlib-dynamic"})) {
#?                       push(@libs, $withargs{zlib_lib} // "ZLIB1");
#?                   }
#?               }
#?               unless ($disabled{zstd}) {
#?                   if (defined($disabled{"zstd-dynamic"})) {
#?                       push(@libs, $withargs{zstd_lib} // "libzstd");
#?                   }
#?               }
#?               unless ($disabled{brotli}) {
#?                   if (defined($disabled{"brotli-dynamic"})) {
#?                       my $path = "";
#?                       if (defined($withargs{brotli_lib})) {
#?                           $path = $withargs{brotli_lib} . "\\";
#?                       }
#?                       push(@libs, $path . "brotlicommon.lib");
#?                       push(@libs, $path . "brotlidec.lib");
#?                       push(@libs, $path . "brotlienc.lib");
#?                   }
#?               }
#?               return join(" ", @libs);
#?           },

#?       MT              => "mt",
#?       MTFLAGS         => "-nologo",
#?       mtinflag        => "-manifest ",
#?       mtoutflag       => "-outputresource:",

endmacro ()

# Win64 targets, WIN64A denotes AMD64
#
# Note about /wd4090, disable warning C4090. This warning returns false
# positives in some situations. Disabling it altogether masks both
# legitimate and false cases, but as we compile on multiple platforms,
# we rely on other compilers to catch legitimate cases.
#
# Also note that we force threads no matter what.  Configuring "no-threads"
# is ignored.
#
# UNICODE is defined in VC-common and applies to all targets. It used to
# be an opt-in option for VC-WIN32, but not anymore. The original reason
# was because ANSI API was *native* system interface for no longer
# supported Windows 9x. Keep in mind that UNICODE only affects how
# OpenSSL libraries interact with underlying OS, it doesn't affect API
# that OpenSSL presents to application.
macro(base_vc)
    set(OPENSSL_THREADS_WINNT 1)
    set(DSO_SCHEME_WIN32 1)
    base_windows()
#?       CFLAGS           => "/W3 /wd4090 /nologo",
#?       coutflag         => "/Fo",
#?       LD               => "link",
#?       LDFLAGS          => "/nologo /debug",
#?       ldoutflag        => "/out:",
#?       ldpostoutflag    => "",
#?       ld_resp_delim    => "\n",
    add_link_options(setargv.obj)
#?       makedep_scheme   => 'VC',
#?       AR               => "lib",
#?       ARFLAGS          => "/nologo",
#?       aroutflag        => "/out:",
#?       ar_resp_delim    => "\n",
#?       RC               => "rc",
#?       rcoutflag        => "/fo",
    set(DEFINES
       OPENSSL_SYS_WIN32 WIN32_LEAN_AND_MEAN
       UNICODE _UNICODE
       _CRT_SECURE_NO_DEPRECATE
       _WINSOCK_DEPRECATED_NO_WARNINGS_)
#?       lib_cflags       => add("/Zi /Fdossl_static.pdb"),
#?       dso_cflags       => "/Zi /Fddso.pdb",
#?       bin_cflags       => "/Zi /Fdapp.pdb",
#?       lddefflag        => "/def:",
#?       ldresflag        => " ",
#?       ld_implib_flag   => "/implib:",
#?       perl_platform    => 'Windows::MSVC',
endmacro ()

macro(base_vc_noce)
    base_vc()
#?       CFLAGS           => add(picker(debug   => '/Od',
#?                                      release => '/O2')),
#?       cflags           => add(picker(default => '/Gs0 /GF /Gy',
#?                                      debug   =>
#?                                      sub {
#?                                          ($disabled{shared} ? "" : "/MDd");
#?                                      },
#?                                      release =>
#?                                      sub {
#?                                          ($disabled{shared} ? "" : "/MD");
#?                                      })),
#? defines          => add(picker(default => [], # works as type cast
#?                                      debug   => [ "DEBUG", "_DEBUG" ])),
#?       lib_cflags       => add(sub { $disabled{shared} ? "/MT /Zl" : () }),
    # Following might/should appears controversial, i.e. defining
    # /MDd without evaluating $disabled{shared}. It works in
    # non-shared build because static library is compiled with /Zl
    # and bares no reference to specific RTL. And it works in
    # shared build because multiple /MDd options are not prohibited.
    # But why /MDd in static build? Well, basically this is just a
    # reference point, which allows to catch eventual errors that
    # would prevent those who want to wrap OpenSSL into own .DLL.
    # Why not /MD in release build then? Well, some are likely to
    # prefer [non-debug] openssl.exe to be free from Micorosoft RTL
    # redistributable.
#?       bin_cflags       => add(picker(debug   => "/MDd",
#?                                      release => sub { $disabled{shared} ? "/MT" : () },
#?                                     )),
    add_link_options(/subsystem:console /opt:ref)
#?       ex_libs          => add(sub {
#?           my @ex_libs = ();
#?           push @ex_libs, 'ws2_32.lib' unless $disabled{sock};
#?           push @ex_libs, 'gdi32.lib advapi32.lib crypt32.lib user32.lib';
#?           return join(" ", @ex_libs);
endmacro ()

macro(base_vc_win64)
    base_vc_noce()
#?       ex_libs          => add(sub {
#?           my @ex_libs = ();
#?           push @ex_libs, 'bufferoverflowu.lib' if (`cl 2>&1` =~ /14\.00\.4[0-9]{4}\./);
#?           return join(" ", @_, @ex_libs);
#?       }),
    set(SIXTY_FOUR_BIT 1)
endmacro ()

macro(vc_win64a)
    base_vc_win64()
    set(UPLINK_ARCH x86_64)
endmacro ()

macro(vc_win32)
    base_vc_noce()
    set(BN_LLONG 1)
    set(UPLINK_ARCH common)
#?       perlasm_scheme   => sub { vc_win32_info()->{perlasm_scheme} },
endmacro ()

macro(vc_win64_clangasm_arm)
    base_vc_noce()
#?       defines         => add("_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE",
#?                              "OPENSSL_SYS_WIN_CORE"),
    set(SIXTY_FOUR_BIT 1)
    set(RC4_CHAR 1)
#?       ASFLAGS   => "/nologo /Zi",
#?       asflags   => "/c",
#?       asoutflag => "/Fo",
    set(PERLASM_SCHEME win64)
    set(UPLINK_ARCH armv8)
endmacro ()

macro(vc_clang_win64_clangasm_arm)
    base_vc_noce()
    set(DEFINES ${DEFINES}
        _ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE
        OPENSSL_SYS_WIN_CORE)
    set(SIXTY_FOUR_BIT 1)
    set(RC4_CHAR 1)
#?       ASFLAGS   => "/nologo /Zi",
#?       asflags   => "/c",
#?       asoutflag => "/Fo",
    set(PERLASM_SCHEME win64)
    set(UPLINK_ARCH armv8)
endmacro ()

# /NODEFAULTLIB:kernel32.lib is needed, because MSVCRT.LIB has
# hidden reference to kernel32.lib, but we don't actually want
# it in "onecore" build.
macro(vc_win32_onecore)
    vc_win32()
    add_link_options(/NODEFAULTLIB:kernel32.lib)
    set(DEFINES ${DEFINES} OPENSSL_SYS_WIN_CORE)
    target_link_libraries(crypto onecore.lib)
endmacro ()

macro(vc_win64a_onecore)
    vc_win64a()
    add_link_options(/NODEFAULTLIB:kernel32.lib)
    set(DEFINES ${DEFINES} OPENSSL_SYS_WIN_CORE)
    target_link_libraries(crypto onecore.lib)
endmacro ()

# But if you want to build library with Windows 10 Version 1809 SDK or
# earlier, the 'disable' attribute should also have 'asm'.
macro(vc_win32_uwp)
    vc_win32_onecore()
    add_link_options(/APPCONTAINER)
    set(DEFINES ${DEFINES} 
        WINAPI_FAMILY=WINAPI_FAMILY_APP _WIN32_WINNT=0x0A00)
    set(DSO_SCHEME_ 1)
    target_link_libraries(crypto WindowsApp.lib)
    set(OPENSSL_NO_UI_CONSOLE 1)
    set(OPENSSL_NO_STDIO 1)
    set(OPENSSL_NO_ASYNC 1)
    set(OPENSSL_NO_UPLINK 1)
endmacro ()

macro(vc_win64a_uwp)
    vc_win64a_onecore()
    add_link_options(/APPCONTAINER)
    add_compile_definitions(WINAPI_FAMILY=WINAPI_FAMILY_APP _WIN32_WINNT=0x0A00)
    set(DSO_SCHEME_ 1)
    target_link_libraries(crypto WindowsApp.lib)
    set(OPENSSL_NO_UI_CONSOLE 1)
    set(OPENSSL_NO_STDIO 1)
    set(OPENSSL_NO_ASYNC 1)
    set(OPENSSL_NO_UPLINK 1)
endmacro ()
