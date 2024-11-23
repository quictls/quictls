#! /usr/bin/env perl
# Copyright 2015-2023 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html


use strict;
use warnings;

use OpenSSL::Test qw/:DEFAULT srctop_file srctop_dir bldtop_file bldtop_dir data_dir/;
use OpenSSL::Test::Utils;
use Cwd qw(abs_path);

BEGIN {
    setup("test_defltfips");
}

use lib srctop_dir('Configurations');
use lib bldtop_dir('.');

plan skip_all => "Configuration loading is turned off"
    if disabled("autoload-config");

plan tests => 1;

$ENV{OPENSSL_CONF} = abs_path(srctop_file("test", "default.cnf"));
ok(run(test(["defltfips_test"])), "running defltfips_test");
