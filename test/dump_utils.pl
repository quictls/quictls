#! /usr/bin/env perl
my $srctop = $ENV{SRCTOP} || $ENV{TOP};
my $bldtop = $ENV{BLDTOP} || $ENV{TOP};

use File::Spec::Functions qw/catdir catfile curdir abs2rel rel2abs/;
use File::Basename;
use Data::Dumper;

$ENV{BUILD_CONF} = rel2abs(catfile($bldtop, "test", "testvars.pm"));

print $ENV{BUILD_CONF} . "\n";

use lib "$FindBin::Bin/../util/perl";

BEGIN {
    my $srctop = $ENV{SRCTOP} || $ENV{TOP};
    push @INC, rel2abs(catfile($srctop, "util", "perl"));
}

use OpenSSL::Test::Utils qw/ disabled /;

OpenSSL::Test::Utils::load_configdata();

print qq(ASM disabled @{[disabled("asm")]} \n);
print qq(FIPS disabled @{[disabled("fips")]} \n);
print Dumper(\[OpenSSL::Test::Utils::available_protocols("tls")]);
