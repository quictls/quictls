#! /usr/bin/env perl
use strict;
use warnings;

##
## Handle enable-xxx and disable-xxx options.
## (For now, just set/clear a variable without any checking.
##

sub
enable
{
    my $arg = uc shift;
    $arg =~ s/ENABLE-//;
    print "set(OPENSSL_NO_${arg} \"\")\n";
}

# For now, just set a variable without any checking.
sub
disable
{
    my $arg = uc shift;
    $arg =~ s/(NO|DISABLE)-//;
    print "set(OPENSSL_NO_${arg} 1)\n";
}

# Scan environment; for now, just warn.
my @warnvars = (
    'AR', 'ARFLAGS',
    'AS', 'ASFLAGS',
    'CC', 'CFLAGS',
    'CXX', 'CXXFLAGS',
    'CPP', 'CPPFLAGS',
    'CPPDEFINES',
    'CPPINCLUDES',
    'CROSS_COMPILE',
    'HASHBANGPERL',
    'LD', 'LDFLAGS', 'LDLIBS',
    'MT', 'MTFLAGS',
    'PERL',
    'RANLIB',
    'RC', 'RCFLAGS',
    'RM',
);
my @found = grep { defined $ENV{$_} } @warnvars;
if ( $#found >= 0 ) {
    warn "Ignoring the following environment variables:\n";
    foreach my $var ( @found ) {
        warn "\t$var\n"
    }
    warn "You might have to edit the cmake configuration.\n";
}

# Skip the command if the cut/pasted the whole line
shift @ARGV if $ARGV[0] =~ m@(./)?config@ || $ARGV[0] =~ m@(./)?Configure@;

# Arguments to skip
my %skipargs = (
    '--banner=' => 1,
    '--fipskey' => 1,
    '--cross-compile-prefix' => 1,
    '--config' => 1,
    '-rpath' => 1,
    '-R' => 1,
    '-Wl,' => 1,
    '-Wp,' => 1,
    '-L' => 1,
    '-v' => 1,
    '-framework' => 1,
    '-w' => 1,
    '-t' => 1,
    '--debug' => 1,
    '--release' => 1,
    '386' => 1,
    'rsaref' => 1,
);

# Scan arguments.
my $cppdefs = "";
while ( @ARGV ) {
    $_ = shift @ARGV;

    # Convert to enable-xxx form
    s/^-?-?shared$/enable-shared/;
    s/^sctp$/enable-sctp/;
    s/^threads$/enable-threads/;
    s/^zlib$/enable-zlib/;
    s/^zlib-dynamic$/enable-zlib-dynamic/;
    s/^fips$/enable-fips/;

    if ( m|^\w+=.+$| ) {
        warn "Ignoring assignment parameter $_\n";
    }
    elsif ( defined $skipargs{$_} ) {
        warn "Skipping $_\n";
    }
    elsif ( /--prefix=(.*)/ ) {
        print "set(INSTALLPREFIX $1)\n";
    }
    elsif ( /--with-([^-]+)-lib=(.*)/ ) {
        my $prot = uc $1;
        my $arg = $2;
        print "set(${prot}LIB $arg)\n";
    }
    elsif ( /--with-([^-]+)-include=(.*)/ ) {
        my $prot = uc $1;
        my $arg = $2;
        print "set(${prot}INCLUDE $arg)\n";
    }
    elsif ( /-([DUI])(.*)/ ) {
        $cppdefs .= ' ' . $_;
    }
    elsif ( /-d/ or /--debug/ or /--release/ ) {
        warn "Set build type debug/release via cmake\n";
    }
    elsif ( /enable-(.*)/ ) {
        enable($1);
    }
    elsif ( /disable-(.*)/ or /no-(.*)/ ) {
        disable($1);
    } elsif ( /-Wall/ || /-Werror/ || /--strict-warnings/ ) {
        print "set(STRICT_WARNINGS 1)\n";
    } else {
        warn "Unknown option $_\n";
    }
}

print "set(CMAKE_C_FLAGS \"\${CMAKE_C_FLAGS} $cppdefs\")n"
    if $cppdefs;


exit 0;
