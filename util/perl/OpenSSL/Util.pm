#! /usr/bin/env perl
# Copyright 2018-2023 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html

package OpenSSL::Util;

use strict;
use warnings;

use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
$VERSION = "0.1";
@ISA = qw(Exporter);
@EXPORT = qw(fixup_cmd_elements fixup_cmd);
@EXPORT_OK = qw();

=head1 NAME

OpenSSL::Util - small OpenSSL utilities

=head1 SYNOPSIS

  use OpenSSL::Util;

=head1 DESCRIPTION


=cut

=over 4

=item fixup_cmd_elements LIST

Fixes up the command line elements given by LIST in a platform specific
manner.

The result of this function is a copy of LIST with strings where quotes and
escapes have been injected as necessary depending on the content of each
LIST string.

This can also be used to put quotes around the executable of a command.

=back

=cut

sub fixup_cmd_elements {
    # A formatter for the command arguments, defaulting to the Unix setup
    my $arg_formatter =
        sub { $_ = shift;
              ($_ eq '' || /\s|[\{\}\\\$\[\]\*\?\|\&:;<>]/) ? "'$_'" : $_ };

    if ( $^O eq "MSWin32") { # MSWin setup
        $arg_formatter = sub {
            $_ = shift;
            if ($_ eq '' || /\s|["\|\&\*\;<>]/) {
                s/(["\\])/\\$1/g;
                '"'.$_.'"';
            } else {
                $_;
            }
        };
    }

    return ( map { $arg_formatter->($_) } @_ );
}

=over 4

=item fixup_cmd LIST

This is a sibling of fixup_cmd_elements() that expects the LIST to be a
complete command line.  It does the same thing as fixup_cmd_elements().

=back

=cut

sub fixup_cmd {
    return fixup_cmd_elements(@_);
}

1;
