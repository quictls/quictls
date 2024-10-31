#! /usr/bin/env perl
# Copyright 2017-2023 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html


use strict;
use warnings;

use File::Spec;
use OpenSSL::Test qw/:DEFAULT srctop_file/;
use OpenSSL::Test::Utils;

# 'supported' and 'unsupported' reflect the current state of things.  In
# Test::More terms, 'supported' works exactly like ok(run(whatever)), while
# 'unsupported' wraps that in a TODO: { } block.
#
# The first argument is the test name (this becomes the last argument to
# 'ok')
# The remaining argument are passed unchecked to 'run'.

# 1:    the result of app() or similar, i.e. something you can pass to
sub supported_pass {
    my $str = shift;

    ok(run(@_), $str);
}

sub supported_fail {
    my $str = shift;

    ok(!run(@_), $str);
}

setup("test_genec");

plan skip_all => "This test is unsupported in a no-ec build"
    if disabled("ec");

my @prime_curves = qw(
    secp112r1
    secp112r2
    secp128r1
    secp128r2
    secp160k1
    secp160r1
    secp160r2
    secp192k1
    secp224k1
    secp224r1
    secp256k1
    secp384r1
    secp521r1
    prime192v1
    prime192v2
    prime192v3
    prime239v1
    prime239v2
    prime239v3
    prime256v1
    wap-wsg-idm-ecid-wtls6
    wap-wsg-idm-ecid-wtls7
    wap-wsg-idm-ecid-wtls8
    wap-wsg-idm-ecid-wtls9
    wap-wsg-idm-ecid-wtls12
    brainpoolP160r1
    brainpoolP160t1
    brainpoolP192r1
    brainpoolP192t1
    brainpoolP224r1
    brainpoolP224t1
    brainpoolP256r1
    brainpoolP256t1
    brainpoolP320r1
    brainpoolP320t1
    brainpoolP384r1
    brainpoolP384t1
    brainpoolP512r1
    brainpoolP512t1
);

my @other_curves = ();
push(@other_curves, 'SM2')
    if !disabled("sm2");

my @curve_aliases = qw(
    P-192
    P-224
    P-256
    P-384
    P-521
);

my @curve_list = ();
push(@curve_list, @prime_curves);
push(@curve_list, @other_curves);
push(@curve_list, @curve_aliases);

my %params_encodings =
    (
     'named_curve'      => \&supported_pass,
     'explicit'         => \&supported_pass
    );

my @output_formats = ('PEM', 'DER');

plan tests => scalar(@curve_list) * scalar(keys %params_encodings)
    * (1 + scalar(@output_formats)) # Try listed @output_formats and text output
    * 2                             # Test generating parameters and keys
    + 1                             # Checking that with no curve it fails
    + 1                             # Checking that with unknown curve it fails
    + 1                             # base serializer test
    ;

ok(!run(app([ 'openssl', 'genpkey',
              '-algorithm', 'EC'])),
   "genpkey EC with no params should fail");

ok(!run(app([ 'openssl', 'genpkey',
              '-algorithm', 'EC',
              '-pkeyopt', 'ec_paramgen_curve:bogus_foobar_curve'])),
   "genpkey EC with unknown curve name should fail");

ok(run(app([ 'openssl', 'genpkey',
             '-provider-path', 'providers',
             '-provider', 'base',
             '-config', srctop_file("test", "default.cnf"),
             '-algorithm', 'EC',
             '-pkeyopt', 'ec_paramgen_curve:prime256v1',
             '-text'])),
    "generate a private key and serialize it using the base provider");

foreach my $curvename (@curve_list) {
    foreach my $paramenc (sort keys %params_encodings) {
        my $fn = $params_encodings{$paramenc};

        # --- Test generating parameters ---

        $fn->("genpkey EC params ${curvename} with ec_param_enc:'${paramenc}' (text)",
              app([ 'openssl', 'genpkey', '-genparam',
                    '-algorithm', 'EC',
                    '-pkeyopt', 'ec_paramgen_curve:'.$curvename,
                    '-pkeyopt', 'ec_param_enc:'.$paramenc,
                    '-text']));

        foreach my $outform (@output_formats) {
            my $outfile = "ecgen.${curvename}.${paramenc}." . lc $outform;
            $fn->("genpkey EC params ${curvename} with ec_param_enc:'${paramenc}' (${outform})",
                  app([ 'openssl', 'genpkey', '-genparam',
                        '-algorithm', 'EC',
                        '-pkeyopt', 'ec_paramgen_curve:'.$curvename,
                        '-pkeyopt', 'ec_param_enc:'.$paramenc,
                        '-outform', $outform,
                        '-out', $outfile]));
        }

        # --- Test generating actual keys ---

        $fn->("genpkey EC key on ${curvename} with ec_param_enc:'${paramenc}' (text)",
              app([ 'openssl', 'genpkey',
                    '-algorithm', 'EC',
                    '-pkeyopt', 'ec_paramgen_curve:'.$curvename,
                    '-pkeyopt', 'ec_param_enc:'.$paramenc,
                    '-text']));

        foreach my $outform (@output_formats) {
            my $outfile = "ecgen.${curvename}.${paramenc}." . lc $outform;
            my $outpubfile = "ecgen.${curvename}.${paramenc}-pub." . lc $outform;
            $fn->("genpkey EC key on ${curvename} with ec_param_enc:'${paramenc}' (${outform})",
                  app([ 'openssl', 'genpkey',
                        '-algorithm', 'EC',
                        '-pkeyopt', 'ec_paramgen_curve:'.$curvename,
                        '-pkeyopt', 'ec_param_enc:'.$paramenc,
                        '-outform', $outform,
                        '-out', $outfile,
                        '-outpubkey', $outpubfile]));
        }
    }
}
