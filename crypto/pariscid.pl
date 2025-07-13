#! /usr/bin/env perl
# Copyright 2009-2020 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html


# $output is the last argument if it looks like a file (it has an extension)
# $flavour is the first argument if it doesn't look like a file
$output = $#ARGV >= 0 && $ARGV[$#ARGV] =~ m|\.\w+$| ? pop : undef;
$flavour = $#ARGV >= 0 && $ARGV[0] !~ m|\.| ? shift : undef;

$output and open STDOUT,">$output";

if ($flavour =~ /64/) {
	$LEVEL		="2.0W";
	$SIZE_T		=8;
	$ST		="std";
} else {
	$LEVEL		="1.1";
	$SIZE_T		=4;
	$ST		="stw";
}

$rp="%r2";
$sp="%r30";
$rv="%r28";

$code=<<___;
	.LEVEL	$LEVEL
	.SPACE	\$TEXT\$
	.SUBSPA	\$CODE\$,QUAD=0,ALIGN=8,ACCESS=0x2C,CODE_ONLY

	.EXPORT	OPENSSL_cpuid_setup,ENTRY
	.ALIGN	8
OPENSSL_cpuid_setup
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	bv	($rp)
	.EXIT
	nop
	.PROCEND

	.EXPORT	OPENSSL_rdtsc,ENTRY
	.ALIGN	8
OPENSSL_rdtsc
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	mfctl	%cr16,$rv
	bv	($rp)
	.EXIT
	nop
	.PROCEND
___
{
my $inp="%r26";
my $len="%r25";

$code.=<<___;
	.EXPORT	OPENSSL_cleanse,ENTRY,ARGW0=GR,ARGW1=GR
	.ALIGN	8
OPENSSL_cleanse
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	cmpib,*=	0,$len,L\$done
	nop
	cmpib,*>>=	15,$len,L\$ittle
	ldi		$SIZE_T-1,%r1

L\$align
	and,*<>		$inp,%r1,%r28
	b,n		L\$aligned
	stb		%r0,0($inp)
	ldo		-1($len),$len
	b		L\$align
	ldo		1($inp),$inp

L\$aligned
	andcm		$len,%r1,%r28
L\$ot
	$ST		%r0,0($inp)
	addib,*<>	-$SIZE_T,%r28,L\$ot
	ldo		$SIZE_T($inp),$inp

	and,*<>		$len,%r1,$len
	b,n		L\$done
L\$ittle
	stb		%r0,0($inp)
	addib,*<>	-1,$len,L\$ittle
	ldo		1($inp),$inp
L\$done
	bv		($rp)
	.EXIT
	nop
	.PROCEND
___
}
{
my ($in1,$in2,$len)=("%r26","%r25","%r24");

$code.=<<___;
	.EXPORT	CRYPTO_memcmp,ENTRY,ARGW0=GR,ARGW1=GR,ARGW1=GR
	.ALIGN	8
CRYPTO_memcmp
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	cmpib,*=	0,$len,L\$no_data
	xor		$rv,$rv,$rv

L\$oop_cmp
	ldb		0($in1),%r19
	ldb		0($in2),%r20
	ldo		1($in1),$in1
	ldo		1($in2),$in2
	xor		%r19,%r20,%r29
	addib,*<>	-1,$len,L\$oop_cmp
	or		%r29,$rv,$rv

	sub		%r0,$rv,%r29
	extru		%r29,0,1,$rv
L\$no_data
	bv		($rp)
	.EXIT
	nop
	.PROCEND
___
}

if (`$ENV{CC} -Wa,-v -c -o /dev/null -x assembler /dev/null 2>&1`
	=~ /GNU assembler/) {
    $gnuas = 1;
}

foreach(split("\n",$code)) {

	s/(\.LEVEL\s+2\.0)W/$1w/	if ($gnuas && $SIZE_T==8);
	s/\.SPACE\s+\$TEXT\$/.text/	if ($gnuas && $SIZE_T==8);
	s/\.SUBSPA.*//			if ($gnuas && $SIZE_T==8);
	s/cmpib,\*/comib,/		if ($SIZE_T==4);
	s/,\*/,/			if ($SIZE_T==4);
	s/\bbv\b/bve/			if ($SIZE_T==8);

	print $_,"\n";
}
close STDOUT or die "error closing STDOUT: $!";

