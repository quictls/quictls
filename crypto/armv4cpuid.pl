#! /usr/bin/env perl
# Copyright 2015-2023 The OpenSSL Project Authors. All Rights Reserved.
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
( $xlate="${dir}arm-xlate.pl" and -f $xlate ) or
( $xlate="${dir}perlasm/arm-xlate.pl" and -f $xlate) or
die "can't locate arm-xlate.pl";

open OUT,"| \"$^X\" $xlate $flavour \"$output\""
    or die "can't call $xlate: $!";
*STDOUT=*OUT;

$code.=<<___;
#include "arm_arch.h"

#if defined(__thumb2__) && !defined(__APPLE__)
.syntax	unified
.thumb
#else
.code	32
#undef	__thumb2__
#endif

.text

.align	5
.global	OPENSSL_atomic_add
.type	OPENSSL_atomic_add,%function
OPENSSL_atomic_add:
#if __ARM_ARCH__>=6
.Ladd:	ldrex	r2,[r0]
	add	r3,r2,r1
	strex	r2,r3,[r0]
	cmp	r2,#0
	bne	.Ladd
	mov	r0,r3
	bx	lr
#else
	stmdb	sp!,{r4-r6,lr}
	ldr	r2,.Lspinlock
	adr	r3,.Lspinlock
	mov	r4,r0
	mov	r5,r1
	add	r6,r3,r2	@ &spinlock
	b	.+8
.Lspin:	bl	sched_yield
	mov	r0,#-1
	swp	r0,r0,[r6]
	cmp	r0,#0
	bne	.Lspin

	ldr	r2,[r4]
	add	r2,r2,r5
	str	r2,[r4]
	str	r0,[r6]		@ release spinlock
	ldmia	sp!,{r4-r6,lr}
	tst	lr,#1
	moveq	pc,lr
	.word	0xe12fff1e	@ bx	lr
#endif
.size	OPENSSL_atomic_add,.-OPENSSL_atomic_add

.global	OPENSSL_cleanse
.type	OPENSSL_cleanse,%function
OPENSSL_cleanse:
	eor	ip,ip,ip
	cmp	r1,#7
#ifdef	__thumb2__
	itt	hs
#endif
	subhs	r1,r1,#4
	bhs	.Lot
	cmp	r1,#0
	beq	.Lcleanse_done
.Little:
	strb	ip,[r0],#1
	subs	r1,r1,#1
	bhi	.Little
	b	.Lcleanse_done

.Lot:	tst	r0,#3
	beq	.Laligned
	strb	ip,[r0],#1
	sub	r1,r1,#1
	b	.Lot
.Laligned:
	str	ip,[r0],#4
	subs	r1,r1,#4
	bhs	.Laligned
	adds	r1,r1,#4
	bne	.Little
.Lcleanse_done:
#if __ARM_ARCH__>=5
	bx	lr
#else
	tst	lr,#1
	moveq	pc,lr
	.word	0xe12fff1e	@ bx	lr
#endif
.size	OPENSSL_cleanse,.-OPENSSL_cleanse

.global	CRYPTO_memcmp
.type	CRYPTO_memcmp,%function
.align	4
CRYPTO_memcmp:
	eor	ip,ip,ip
	cmp	r2,#0
	beq	.Lno_data
	stmdb	sp!,{r4,r5}

.Loop_cmp:
	ldrb	r4,[r0],#1
	ldrb	r5,[r1],#1
	eor	r4,r4,r5
	orr	ip,ip,r4
	subs	r2,r2,#1
	bne	.Loop_cmp

	ldmia	sp!,{r4,r5}
.Lno_data:
	rsb	r0,ip,#0
	mov	r0,r0,lsr#31
#if __ARM_ARCH__>=5
	bx	lr
#else
	tst	lr,#1
	moveq	pc,lr
	.word	0xe12fff1e	@ bx	lr
#endif
.size	CRYPTO_memcmp,.-CRYPTO_memcmp

#if __ARM_MAX_ARCH__>=7
.arch	armv7-a
.fpu	neon

.align	5
.global	_armv7_neon_probe
.type	_armv7_neon_probe,%function
_armv7_neon_probe:
	vorr	q0,q0,q0
	bx	lr
.size	_armv7_neon_probe,.-_armv7_neon_probe

.global	_armv7_tick
.type	_armv7_tick,%function
_armv7_tick:
#ifdef	__APPLE__
	mrrc	p15,0,r0,r1,c14		@ CNTPCT
#else
	mrrc	p15,1,r0,r1,c14		@ CNTVCT
#endif
	bx	lr
.size	_armv7_tick,.-_armv7_tick

.global	_armv8_aes_probe
.type	_armv8_aes_probe,%function
_armv8_aes_probe:
#if defined(__thumb2__) && !defined(__APPLE__)
	.byte	0xb0,0xff,0x00,0x03	@ aese.8	q0,q0
#else
	.byte	0x00,0x03,0xb0,0xf3	@ aese.8	q0,q0
#endif
	bx	lr
.size	_armv8_aes_probe,.-_armv8_aes_probe

.global	_armv8_sha1_probe
.type	_armv8_sha1_probe,%function
_armv8_sha1_probe:
#if defined(__thumb2__) && !defined(__APPLE__)
	.byte	0x00,0xef,0x40,0x0c	@ sha1c.32	q0,q0,q0
#else
	.byte	0x40,0x0c,0x00,0xf2	@ sha1c.32	q0,q0,q0
#endif
	bx	lr
.size	_armv8_sha1_probe,.-_armv8_sha1_probe

.global	_armv8_sha256_probe
.type	_armv8_sha256_probe,%function
_armv8_sha256_probe:
#if defined(__thumb2__) && !defined(__APPLE__)
	.byte	0x00,0xff,0x40,0x0c	@ sha256h.32	q0,q0,q0
#else
	.byte	0x40,0x0c,0x00,0xf3	@ sha256h.32	q0,q0,q0
#endif
	bx	lr
.size	_armv8_sha256_probe,.-_armv8_sha256_probe
.global	_armv8_pmull_probe
.type	_armv8_pmull_probe,%function
_armv8_pmull_probe:
#if defined(__thumb2__) && !defined(__APPLE__)
	.byte	0xa0,0xef,0x00,0x0e	@ vmull.p64	q0,d0,d0
#else
	.byte	0x00,0x0e,0xa0,0xf2	@ vmull.p64	q0,d0,d0
#endif
	bx	lr
.size	_armv8_pmull_probe,.-_armv8_pmull_probe
#endif

.align	5
#if __ARM_MAX_ARCH__>=7
.LOPENSSL_armcap:
.word	OPENSSL_armcap_P-.
#endif
#if __ARM_ARCH__>=6
.align	5
#else
.Lspinlock:
.word	atomic_add_spinlock-.Lspinlock
.align	5

.data
.align	2
atomic_add_spinlock:
.word	0
#endif

.extern	OPENSSL_armcap_P
___

print $code;
close STDOUT or die "error closing STDOUT: $!";
