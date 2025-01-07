#! /usr/bin/env perl
# Copyright 2015-2022 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html

use strict;
use warnings;

BEGIN {
    $ENV{HARNESS_VERBOSE} = "yes" if $ENV{VERBOSE} || $ENV{V};
}

use File::Spec::Functions qw/catdir catfile curdir abs2rel rel2abs/;
use File::Basename;
use FindBin;
use TAP::Harness;
use TAP::Parser;
use lib "$FindBin::Bin/../util/perl";

my $srctop = $ENV{SRCTOP} || $ENV{TOP};
my $bldtop = $ENV{BLDTOP} || $ENV{TOP};
my $recipesdir = catdir($srctop, "test", "recipes");
my $libdir = rel2abs(catdir($srctop, "util", "perl"));
my $jobs = $ENV{HARNESS_JOBS} // 1;

$ENV{OPENSSL_CONF} = rel2abs(catfile($srctop, "apps", "openssl.cnf"));
$ENV{OPENSSL_CONF_INCLUDE} = rel2abs(catdir($bldtop, "test"));
$ENV{OPENSSL_MODULES} = rel2abs(catdir($bldtop, "providers"));
$ENV{OPENSSL_ENGINES} = rel2abs(catdir($bldtop, "engines"));
$ENV{CTLOG_FILE} = rel2abs(catfile($srctop, "test", "ct", "log_list.cnf"));

# On platforms that support this, this will ensure malloc returns data that is
# set to a non-zero value. Can be helpful for detecting uninitialized reads in
# some situations.
$ENV{'MALLOC_PERTURB_'} = '128' if !defined $ENV{'MALLOC_PERTURB_'};

my %tapargs = (
    verbosity         => $ENV{HARNESS_VERBOSE} ? 1 : 0,
    lib               => [ $libdir ],
    switches          => '-w',
    merge             => 1,
    timer             => $ENV{HARNESS_TIMER} ? 1 : 0,
);

sub find_matching_tests {
    my ($glob) = @_;

    if ($glob =~ m|^[\d\[\]\?\-]+$|) {
        return glob(catfile($recipesdir,"$glob-*.t"));
    }
    return glob(catfile($recipesdir,"*-$glob.t"));
}

if ($jobs > 1) {
    if ($ENV{HARNESS_VERBOSE}) {
        print "Warning: HARNESS_JOBS > 1 ignored with HARNESS_VERBOSE\n";
    } else {
        $tapargs{jobs} = $jobs;
        print "Using HARNESS_JOBS=$jobs\n";
    }
}

# Collect the tests to run.
my @alltests = find_matching_tests("*");
my %tests = ();
my $first = 1;
foreach my $arg (@ARGV ? @ARGV : ('alltests')) {
    if ($arg eq 'list') {
        foreach (@alltests) {
            (my $x = basename($_)) =~ s|^[0-9][0-9]-(.*)\.t$|$1|;
            print $x,"\n";
        }
        exit 0;
    }
    if ($arg eq 'alltests') {
        warn "'alltests' encountered, ignoring everything before that.\n"
            unless $first;
        %tests = map { $_ => 1 } @alltests;
    } elsif ($arg =~ m/^(-?)(.*)/) {
        my $sign = $1;
        my $test = $2;
        my @matches = find_matching_tests($test);

        # If '-foo' is the first arg, it's short for 'alltests -foo'
        %tests = map { $_ => 1 } @alltests
            if $sign eq '-' && $first;

        if (scalar @matches == 0) {
            warn "'$test' has no matches, ignoring it\n";
        } else {
            foreach $test (@matches) {
                if ($sign eq '-') {
                    delete $tests{$test};
                } else {
                    $tests{$test} = 1;
                }
            }
        }
    } else {
        warn "Ignoring '$arg'\n";
    }

    $first = 0;
}

# for parallel test runs, do slow tests first
sub slowfirst {
    my $key = pop;

    if ($jobs > 1 && $key =~ m/test_ssl_new|test_fuzz/) {
        $key =~ s/(\d+)-/01-/;
    }
    return $key;
}


my $harness = TAP::Harness->new(\%tapargs);
my $ret = $harness->runtests(
    map { [ abs2rel($_, rel2abs(curdir())), basename($_) ] }
    sort { slowfirst($a) cmp slowfirst($b) } keys %tests);

exit $ret->has_errors ? 1 : 0;
