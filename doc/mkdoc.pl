# #! /usr/bin/env perl
#
# Copyright 2019-2021 The OpenSSL Project Authors. All Rights Reserved.
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# POD files (mainly man1).

use strict;
use warnings;

# A simple script to insert common option information into a manpage.

my %texts = (
    # Certificate validation options.
certverify_synopsis => ""
    . "[B<-allow_proxy_certs>]\n"
    . "[B<-attime> I<timestamp>]\n"
    . "[B<-no_check_time>]\n"
    . "[B<-check_ss_sig>]\n"
    . "[B<-crl_check>]\n"
    . "[B<-crl_check_all>]\n"
    . "[B<-explicit_policy>]\n"
    . "[B<-extended_crl>]\n"
    . "[B<-ignore_critical>]\n"
    . "[B<-inhibit_any>]\n"
    . "[B<-inhibit_map>]\n"
    . "[B<-partial_chain>]\n"
    . "[B<-policy> I<arg>]\n"
    . "[B<-policy_check>]\n"
    . "[B<-policy_print>]\n"
    . "[B<-purpose> I<purpose>]\n"
    . "[B<-suiteB_128>]\n"
    . "[B<-suiteB_128_only>]\n"
    . "[B<-suiteB_192>]\n"
    . "[B<-trusted_first>]\n"
    . "[B<-no_alt_chains>]\n"
    . "[B<-use_deltas>]\n"
    . "[B<-auth_level> I<num>]\n"
    . "[B<-verify_depth> I<num>]\n"
    . "[B<-verify_email> I<email>]\n"
    . "[B<-verify_hostname> I<hostname>]\n"
    . "[B<-verify_ip> I<ip>]\n"
    . "[B<-verify_name> I<name>]\n"
    . "[B<-x509_strict>]\n"
    . "[B<-issuer_checks>]",
certverify_item => "\n"
    . "=item B<-allow_proxy_certs>, B<-attime>, B<-no_check_time>,\n"
    . "B<-check_ss_sig>, B<-crl_check>, B<-crl_check_all>,\n"
    . "B<-explicit_policy>, B<-extended_crl>, B<-ignore_critical>, B<-inhibit_any>,\n"
    . "B<-inhibit_map>, B<-no_alt_chains>, B<-partial_chain>, B<-policy>,\n"
    . "B<-policy_check>, B<-policy_print>, B<-purpose>, B<-suiteB_128>,\n"
    . "B<-suiteB_128_only>, B<-suiteB_192>, B<-trusted_first>, B<-use_deltas>,\n"
    . "B<-auth_level>, B<-verify_depth>, B<-verify_email>, B<-verify_hostname>,\n"
    . "B<-verify_ip>, B<-verify_name>, B<-x509_strict> B<-issuer_checks>\n"
    . "\n"
    . "Set various options of certificate chain verification.\n"
    . "See L<openssl-verification-options(1)/Verification Options> for details.",
    # Extended validation options.
extverify_synopsis => ""
    . "[B<-xkey> I<infile>]\n"
    . "[B<-xcert> I<file>]\n"
    . "[B<-xchain> I<file>]\n"
    . "[B<-xchain_build> I<file>]\n"
    . "[B<-xcertform> B<DER>|B<PEM>]>\n"
    . "[B<-xkeyform> B<DER>|B<PEM>]>",
extverify_item => "\n"
    . "=item B<-xkey> I<infile>, B<-xcert> I<file>, B<-xchain> I<file>,\n"
    . "B<-xchain_build> I<file>, B<-xcertform> B<DER>|B<PEM>,\n"
    . "B<-xkeyform> B<DER>|B<PEM>\n"
    . "\n"
    . "Set extended certificate verification options.\n"
    . "See L<openssl-verification-options(1)/Extended Verification Options> for details.",

    # Name output options
name_synopsis => ""
    . "[B<-nameopt> I<option>]",
name_item => "\n"
    . "=item B<-nameopt> I<option>\n"
    . "\n"
    . "This specifies how the subject or issuer names are displayed.\n"
    . "See L<openssl-namedisplay-options(1)> for details.",

    # Random State Options
randstate_synopsis => ""
    . "[B<-rand> I<files>]\n"
    . "[B<-writerand> I<file>]",
randstate_item => "\n"
    . "=item B<-rand> I<files>, B<-writerand> I<file>\n"
    . "\n"
    . "See L<openssl(1)/Random State Options> for details.",

    # Provider options
provider_synopsis => ""
    . "[B<-provider> I<name>]\n"
    . "[B<-provider-path> I<path>]\n"
    . "[B<-propquery> I<propq>]",
provider_item => "\n"
    . "=item B<-provider> I<name>\n"
    . "\n"
    . "=item B<-provider-path> I<path>\n"
    . "\n"
    . "=item B<-propquery> I<propq>\n"
    . "\n"
    . "See L<openssl(1)/Provider Options>, L<provider(7)>, and L<property(7)>.",

    # Configuration option
config_synopsis => ""
    . "[B<-config> I<configfile>]",
config_item => "\n"
    . "=item B<-config> I<configfile>\n"
    . "\n"
    . "See L<openssl(1)/Configuration Option>.",

    # Engine options
engine_synopsis => ""
    . "[B<-engine> I<id>]",
engine_item => "\n"
      . "=item B<-engine> I<id>\n"
      . "\n"
      . "See L<openssl(1)/Engine Options>.\n"
      . "This option is deprecated.",
engineimpl_synopsis => ""
    . "[B<-engine> I<id>]\n",
    . "[B<-engine_impl> I<id>]",

    # Trusted certs options
trust_synopsis => ""
    . "[B<-CAfile> I<file>]\n"
    . "[B<-no-CAfile>]\n"
    . "[B<-CApath> I<dir>]\n"
    . "[B<-no-CApath>]\n"
    . "[B<-CAstore> I<uri>]\n"
    . "[B<-no-CAstore>]",
trust_item => "\n"
    . "=item B<-CAfile> I<file>, B<-no-CAfile>, B<-CApath> I<dir>, B<-no-CApath>,\n"
    . "B<-CAstore> I<uri>, B<-no-CAstore>\n"
    . "\n"
    . "See L<openssl-verification-options(1)/Trusted Certificate Options> for details.",

    # TLS Version Options (TLS/DTLS versions set below)
versiontls_synopsis => ""
    . "[B<-no_ssl3>]\n"
    . "[B<-no_tls1>]\n"
    . "[B<-no_tls1_1>]\n"
    . "[B<-no_tls1_2>]\n"
    . "[B<-no_tls1_3>]\n"
    . "[B<-ssl3>]\n"
    . "[B<-tls1>]\n"
    . "[B<-tls1_1>]\n"
    . "[B<-tls1_2>]\n"
    . "[B<-tls1_3>]",
versiontls_item => "\n"
    . "=item B<-no_ssl3>, B<-no_tls1>, B<-no_tls1_1>, B<-no_tls1_2>, B<-no_tls1_3>,\n"
    . "B<-ssl3>, B<-tls1>, B<-tls1_1>, B<-tls1_2>, B<-tls1_3>\n"
    . "\n"
    . "See L<openssl(1)/TLS Version Options>.",

    # SSL connection options.
connoptions_synopsis => ""
    . "[B<-bugs>]\n"
    . "[B<-no_comp>]\n"
    . "[B<-comp>]\n"
    . "[B<-no_ticket>]\n"
    . "[B<-serverpref>]\n"
    . "[B<-client_renegotiation>]\n"
    . "[B<-legacy_renegotiation>]\n"
    . "[B<-no_renegotiation>]\n"
    . "[B<-no_resumption_on_reneg>]\n"
    . "[B<-legacy_server_connect>]\n"
    . "[B<-no_legacy_server_connect>]\n"
    . "[B<-no_etm>]\n"
    . "[B<-allow_no_dhe_kex>]\n"
    . "[B<-prefer_no_dhe_kex>]\n"
    . "[B<-prioritize_chacha>]\n"
    . "[B<-strict>]\n"
    . "[B<-sigalgs> I<algs>]\n"
    . "[B<-client_sigalgs> I<algs>]\n"
    . "[B<-groups> I<groups>]\n"
    . "[B<-curves> I<curves>]\n"
    . "[B<-named_curve> I<curve>]\n"
    . "[B<-cipher> I<ciphers>]\n"
    . "[B<-ciphersuites> I<1.3ciphers>]\n"
    . "[B<-min_protocol> I<minprot>]\n"
    . "[B<-max_protocol> I<maxprot>]\n"
    . "[B<-record_padding> I<padding>]\n"
    . "[B<-debug_broken_protocol>]\n"
    . "[B<-no_middlebox>]",
connoptions_item => "\n"
    . "=item B<-bugs>, B<-comp>, B<-no_comp>, B<-no_ticket>, B<-serverpref>,\n"
    . "B<-client_renegotiation>,\n"
    . "B<-legacy_renegotiation>, B<-no_renegotiation>,\n"
    . "B<-no_resumption_on_reneg>,\n"
    . "B<-legacy_server_connect>, B<-no_legacy_server_connect>, B<-no_etm>\n"
    . "B<-allow_no_dhe_kex>, B<-prefer_no_dhe_kex>,\n"
    . "B<-prioritize_chacha>, B<-strict>, B<-sigalgs>\n"
    . "I<algs>, B<-client_sigalgs> I<algs>, B<-groups> I<groups>, B<-curves>\n"
    . "I<curves>, B<-named_curve> I<curve>, B<-cipher> I<ciphers>, B<-ciphersuites>\n"
    . "I<1.3ciphers>, B<-min_protocol> I<minprot>, B<-max_protocol> I<maxprot>,\n"
    . "B<-record_padding> I<padding>, B<-debug_broken_protocol>, B<-no_middlebox>\n"
    . "\n"
    . "See L<SSL_CONF_cmd(3)/SUPPORTED COMMAND LINE COMMANDS> for details.",
);

    # TLS/DTLS Version Options set below
$texts{"version_synopsis"} = ""
    . $texts{versiontls_synopsis}. "\n"
    . "[B<-dtls>]\n"
    . "[B<-dtls1>]\n"
    . "[B<-dtls1_2>]";
$texts{version_item} = "\n"
    . $texts{versiontls_item}. "\n"
    . "\n"
    . "=item B<-dtls>, B<-dtls1>, B<-dtls1_2>\n"
    . "\n"
    . "These specify the use of DTLS instead of TLS.\n"
    . "See L<openssl(1)/TLS Version Options>.";

die "Need two args, got $#ARGV" if $#ARGV != 1;

open(my $IN, '<', $ARGV[0]) or die "Can't open $ARGV[0], $!";
<$IN>;
open(my $OUT, '>', $ARGV[1]) or die "Can't open $ARGV[1], $!";
print $OUT <<EOF;
=pod

=for comment Generated file, do not edit!
EOF

my @fields;
my $line;
while ( $line = <$IN> ) {
    if ( $line =~ /#include/ ) {
	@fields = split(" ", $line);
	die "Unknown keyword \"$fields[1]\" in $ARGV[1], "
	    unless defined $texts{$fields[1]};
	print $OUT $texts{$fields[1]}, "\n";
    } else {
	print $OUT $line;
    }
}

close($OUT) or die "Can't close $ARGV[2], $!";
