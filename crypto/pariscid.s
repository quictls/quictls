	.LEVEL	1.1
	.SPACE	$TEXT$
	.SUBSPA	$CODE$,QUAD=0,ALIGN=8,ACCESS=0x2C,CODE_ONLY

	.EXPORT	OPENSSL_cpuid_setup,ENTRY
	.ALIGN	8
OPENSSL_cpuid_setup
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	bv	(%r2)
	.EXIT
	nop
	.PROCEND

	.EXPORT	OPENSSL_rdtsc,ENTRY
	.ALIGN	8
OPENSSL_rdtsc
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	mfctl	%cr16,%r28
	bv	(%r2)
	.EXIT
	nop
	.PROCEND

	.EXPORT	OPENSSL_wipe_cpu,ENTRY
	.ALIGN	8
OPENSSL_wipe_cpu
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	xor		%r0,%r0,%r1
	fcpy,dbl	%fr0,%fr4
	xor		%r0,%r0,%r19
	fcpy,dbl	%fr0,%fr5
	xor		%r0,%r0,%r20
	fcpy,dbl	%fr0,%fr6
	xor		%r0,%r0,%r21
	fcpy,dbl	%fr0,%fr7
	xor		%r0,%r0,%r22
	fcpy,dbl	%fr0,%fr8
	xor		%r0,%r0,%r23
	fcpy,dbl	%fr0,%fr9
	xor		%r0,%r0,%r24
	fcpy,dbl	%fr0,%fr10
	xor		%r0,%r0,%r25
	fcpy,dbl	%fr0,%fr11
	xor		%r0,%r0,%r26
	fcpy,dbl	%fr0,%fr22
	xor		%r0,%r0,%r29
	fcpy,dbl	%fr0,%fr23
	xor		%r0,%r0,%r31
	fcpy,dbl	%fr0,%fr24
	fcpy,dbl	%fr0,%fr25
	fcpy,dbl	%fr0,%fr26
	fcpy,dbl	%fr0,%fr27
	fcpy,dbl	%fr0,%fr28
	fcpy,dbl	%fr0,%fr29
	fcpy,dbl	%fr0,%fr30
	fcpy,dbl	%fr0,%fr31
	bv		(%r2)
	.EXIT
	ldo		0(%r30),%r28
	.PROCEND
	.EXPORT	OPENSSL_cleanse,ENTRY,ARGW0=GR,ARGW1=GR
	.ALIGN	8
OPENSSL_cleanse
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	comib,=	0,%r25,L$done
	nop
	comib,>>=	15,%r25,L$ittle
	ldi		4-1,%r1

L$align
	and,<>		%r26,%r1,%r28
	b,n		L$aligned
	stb		%r0,0(%r26)
	ldo		-1(%r25),%r25
	b		L$align
	ldo		1(%r26),%r26

L$aligned
	andcm		%r25,%r1,%r28
L$ot
	stw		%r0,0(%r26)
	addib,<>	-4,%r28,L$ot
	ldo		4(%r26),%r26

	and,<>		%r25,%r1,%r25
	b,n		L$done
L$ittle
	stb		%r0,0(%r26)
	addib,<>	-1,%r25,L$ittle
	ldo		1(%r26),%r26
L$done
	bv		(%r2)
	.EXIT
	nop
	.PROCEND
	.EXPORT	CRYPTO_memcmp,ENTRY,ARGW0=GR,ARGW1=GR,ARGW1=GR
	.ALIGN	8
CRYPTO_memcmp
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	comib,=	0,%r24,L$no_data
	xor		%r28,%r28,%r28

L$oop_cmp
	ldb		0(%r26),%r19
	ldb		0(%r25),%r20
	ldo		1(%r26),%r26
	ldo		1(%r25),%r25
	xor		%r19,%r20,%r29
	addib,<>	-1,%r24,L$oop_cmp
	or		%r29,%r28,%r28

	sub		%r0,%r28,%r29
	extru		%r29,0,1,%r28
L$no_data
	bv		(%r2)
	.EXIT
	nop
	.PROCEND
	.EXPORT	OPENSSL_instrument_bus,ENTRY,ARGW0=GR,ARGW1=GR
	.ALIGN	8
OPENSSL_instrument_bus
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	copy		%r25,%r28
	mfctl		%cr16,%r23
	copy		%r23,%r22
	ldi		0,%r21

	fdc		0(%r26)
	ldw		0(%r26),%r23
	add		%r21,%r23,%r23
	stw		%r23,0(%r26)
L$oop
	mfctl		%cr16,%r23
	sub		%r23,%r22,%r21
	copy		%r23,%r22

	fdc		0(%r26)
	ldw		0(%r26),%r23
	add		%r21,%r23,%r23
	stw		%r23,0(%r26)

	addib,<>	-1,%r25,L$oop
	addi		4,%r26,%r26

	bv		(%r2)
	.EXIT
	sub		%r28,%r25,%r28
	.PROCEND

	.EXPORT	OPENSSL_instrument_bus2,ENTRY,ARGW0=GR,ARGW1=GR
	.ALIGN	8
OPENSSL_instrument_bus2
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	copy		%r25,%r28
	sub		%r0,%r25,%r25

	mfctl		%cr16,%r23
	copy		%r23,%r22
	ldi		0,%r21

	fdc		0(%r26)
	ldw		0(%r26),%r23
	add		%r21,%r23,%r23
	stw		%r23,0(%r26)

	mfctl		%cr16,%r23
	sub		%r23,%r22,%r21
	copy		%r23,%r22
L$oop2
	copy		%r21,%r20
	fdc		0(%r26)
	ldw		0(%r26),%r23
	add		%r21,%r23,%r23
	stw		%r23,0(%r26)

	addib,=		-1,%r24,L$done2
	nop

	mfctl		%cr16,%r23
	sub		%r23,%r22,%r21
	copy		%r23,%r22
	cmpclr,<>	%r20,%r21,%r23
	ldi		1,%r23

	ldi		1,%r1
	xor		%r1,%r23,%r23
	addb,<>		%r23,%r25,L$oop2
	shladd,l	%r23,2,%r26,%r26
L$done2
	bv		(%r2)
	.EXIT
	add		%r28,%r25,%r28
	.PROCEND
