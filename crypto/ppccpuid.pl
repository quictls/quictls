#! /usr/bin/env perl
# Copyright 2007-2022 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html


# $output is the last argument if it looks like a file (it has an extension)
# $flavour is the first argument if it doesn't look like a file
$output = $#ARGV >= 0 && $ARGV[$#ARGV] =~ m|\.\w+$| ? pop : undef;
$flavour = $#ARGV >= 0 && $ARGV[0] !~ m|\.| ? shift : undef;

$0 =~ m/(.*[\/\\])[^\/\\]+$/; $dir=$1;
( $xlate="${dir}ppc-xlate.pl" and -f $xlate ) or
( $xlate="${dir}perlasm/ppc-xlate.pl" and -f $xlate) or
die "can't locate ppc-xlate.pl";

open STDOUT,"| $^X $xlate $flavour \"$output\""
    or die "can't call $xlate: $!";

if ($flavour=~/64/) {
    $CMPLI="cmpldi";
    $SHRLI="srdi";
    $SIGNX="extsw";
} else {
    $CMPLI="cmplwi";
    $SHRLI="srwi";
    $SIGNX="mr";
}

$code=<<___;
.machine	"any"
.text

.globl	.OPENSSL_fpu_probe
.align	4
.OPENSSL_fpu_probe:
	fmr	f0,f0
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,0,0
.size	.OPENSSL_fpu_probe,.-.OPENSSL_fpu_probe
.globl	.OPENSSL_ppc64_probe
.align	4
.OPENSSL_ppc64_probe:
	fcfid	f1,f1
	extrdi	r0,r0,32,0
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,0,0
.size	.OPENSSL_ppc64_probe,.-.OPENSSL_ppc64_probe

.globl	.OPENSSL_altivec_probe
.align	4
.OPENSSL_altivec_probe:
	.long	0x10000484	# vor	v0,v0,v0
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,0,0
.size	.OPENSSL_altivec_probe,.-..OPENSSL_altivec_probe

.globl	.OPENSSL_crypto207_probe
.align	4
.OPENSSL_crypto207_probe:
	lvx_u	v0,0,r1
	vcipher	v0,v0,v0
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,0,0
.size	.OPENSSL_crypto207_probe,.-.OPENSSL_crypto207_probe

.globl	.OPENSSL_madd300_probe
.align	4
.OPENSSL_madd300_probe:
	xor	r0,r0,r0
	maddld	r3,r0,r0,r0
	maddhdu	r3,r0,r0,r0
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,0,0

.globl	.OPENSSL_brd31_probe
.align	4
.OPENSSL_brd31_probe:
	xor	r0,r0,r0
	brd	r3,r0
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,0,0
.size	.OPENSSL_brd31_probe,.-.OPENSSL_brd31_probe

.globl	.OPENSSL_atomic_add
.align	4
.OPENSSL_atomic_add:
Ladd:	lwarx	r5,0,r3
	add	r0,r4,r5
	stwcx.	r0,0,r3
	bne-	Ladd
	$SIGNX	r3,r0
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,2,0
	.long	0
.size	.OPENSSL_atomic_add,.-.OPENSSL_atomic_add

.globl	.OPENSSL_rdtsc_mftb
.align	4
.OPENSSL_rdtsc_mftb:
	mftb	r3
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,0,0
.size	.OPENSSL_rdtsc_mftb,.-.OPENSSL_rdtsc_mftb

.globl	.OPENSSL_rdtsc_mfspr268
.align	4
.OPENSSL_rdtsc_mfspr268:
	mfspr	r3,268
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,0,0
.size	.OPENSSL_rdtsc_mfspr268,.-.OPENSSL_rdtsc_mfspr268

.globl	.OPENSSL_cleanse
.align	4
.OPENSSL_cleanse:
	$CMPLI	r4,7
	li	r0,0
	bge	Lot
	$CMPLI	r4,0
	beqlr-
Little:	mtctr	r4
	stb	r0,0(r3)
	addi	r3,r3,1
	bdnz	\$-8
	blr
Lot:	andi.	r5,r3,3
	beq	Laligned
	stb	r0,0(r3)
	subi	r4,r4,1
	addi	r3,r3,1
	b	Lot
Laligned:
	$SHRLI	r5,r4,2
	mtctr	r5
	stw	r0,0(r3)
	addi	r3,r3,4
	bdnz	\$-8
	andi.	r4,r4,3
	bne	Little
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,2,0
	.long	0
.size	.OPENSSL_cleanse,.-.OPENSSL_cleanse

globl	.CRYPTO_memcmp
.align	4
.CRYPTO_memcmp:
	$CMPLI	r5,0
	li	r0,0
	beq	Lno_data
	mtctr	r5
Loop_cmp:
	lbz	r6,0(r3)
	addi	r3,r3,1
	lbz	r7,0(r4)
	addi	r4,r4,1
	xor	r6,r6,r7
	or	r0,r0,r6
	bdnz	Loop_cmp

Lno_data:
	li	r3,0
	sub	r3,r3,r0
	extrwi	r3,r3,1,0
	blr
	.long	0
	.byte	0,12,0x14,0,0,0,3,0
	.long	0
.size	.CRYPTO_memcmp,.-.CRYPTO_memcmp
___

$code =~ s/\`([^\`]*)\`/eval $1/gem;
print $code;
close STDOUT or die "error closing STDOUT: $!";
