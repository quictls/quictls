	.LEVEL	1.0
	.SPACE	$TEXT$
	.SUBSPA	$CODE$,QUAD=0,ALIGN=8,ACCESS=0x2C,CODE_ONLY

	.EXPORT	RC4,ENTRY,ARGW0=GR,ARGW1=GR,ARGW2=GR,ARGW3=GR
RC4
	.PROC
	.CALLINFO	FRAME=48,NO_CALLS,SAVE_RP,ENTRY_GR=6
	.ENTRY
	stw	%r2,-20(%sp)	; standard prologue
	stwm	%r3,64(%sp)
	stw	%r4,-60(%sp)
	stw	%r5,-56(%sp)
	stw	%r6,-52(%sp)

	comib,= 0,%r25,L$abort
	sub	%r24,%r23,%r24		; distance between %r24 and %r23

	ldb	0(%r26),%r19
	ldb	1(%r26),%r28
	ldo	2(%r26),%r26

	ldi	0xff,%r31
	ldi	3,%r4

	ldo	1(%r19),%r19	; warm up loop
	and	%r31,%r19,%r19
	ldbx	%r19(%r26),%r21
	addl	%r21,%r28,%r28
	comib,>>= 6,%r25,L$oop1	; is %r25 large enough to bother?
	and	%r31,%r28,%r28

	and,<>	%r23,%r4,%r6		; is %r23 aligned?
	b	L$alignedout
	subi	4,%r6,%r6
	sub	%r25,%r6,%r25
L$alignout
	addl	%r28,%r26,%r3
	ldbx	%r28(%r26),%r29
	addl	%r19,%r26,%r2
	stb	%r21,0(%r3)
	ldo	1(%r19),%r19
	stb	%r29,0(%r2)
	addl	%r21,%r29,%r29
	ldbx	%r24(%r23),%r5
	and	%r31,%r29,%r29
	and	%r31,%r19,%r19
	ldbx	%r29(%r26),%r1
	ldbx	%r19(%r26),%r21
	ldo	1(%r23),%r23
	xor	%r5,%r1,%r1
	addl	%r21,%r28,%r28
	stb	%r1,-1(%r23)
	addib,<> -1,%r6,L$alignout	; %r6 is always small
	and	%r31,%r28,%r28
L$alignedout				; %r25 is at least 4 here
	and,<>	%r24,%r4,%r1		; is %r24 aligned?
	b	L$oop4
	sub	%r24,%r1,%r6		; align %r24

	sh3addl	%r1,%r0,%r1
	subi	32,%r1,%r1
	mtctl	%r1,%cr11		; load %sar with vshd align factor
	ldwx	%r6(%r23),%r4
	ldo	4(%r6),%r6
L$oop4misalignedinp
	ldo	1(%r19),%r20
	
	and	%r31,%r20,%r20
	ldbx	%r28(%r26),%r29
	addl	%r28,%r26,%r2
	ldbx	%r20(%r26),%r22
	addl	%r19,%r26,%r3
	stb	%r21,0(%r2)
	comclr,<> %r20,%r28,%r0	; conditional
	copy	%r21,%r22		; move
	
	stb	%r29,0(%r3)
	addl	%r21,%r29,%r29
	addl	%r22,%r28,%r28
	and	%r31,%r29,%r29
	and	%r31,%r28,%r28
	ldo	1(%r20),%r19
	ldbx	%r29(%r26),%r5
	and	%r31,%r19,%r19
	ldbx	%r28(%r26),%r29
	addl	%r28,%r26,%r2
	ldbx	%r19(%r26),%r21
	addl	%r20,%r26,%r3
	stb	%r22,0(%r2)
	comclr,<> %r19,%r28,%r0	; conditional
	copy	%r22,%r21		; move
	zdep	%r5,7,8,%r1
	stb	%r29,0(%r3)
	addl	%r22,%r29,%r29
	addl	%r21,%r28,%r28
	and	%r31,%r29,%r29
	and	%r31,%r28,%r28
	ldo	1(%r19),%r20
	ldbx	%r29(%r26),%r5
	and	%r31,%r20,%r20
	ldbx	%r28(%r26),%r29
	addl	%r28,%r26,%r2
	ldbx	%r20(%r26),%r22
	addl	%r19,%r26,%r3
	stb	%r21,0(%r2)
	comclr,<> %r20,%r28,%r0	; conditional
	copy	%r21,%r22		; move
	dep	%r5,15,8,%r1
	stb	%r29,0(%r3)
	addl	%r21,%r29,%r29
	addl	%r22,%r28,%r28
	and	%r31,%r29,%r29
	and	%r31,%r28,%r28
	ldo	1(%r20),%r19
	ldbx	%r29(%r26),%r5
	and	%r31,%r19,%r19
	ldbx	%r28(%r26),%r29
	addl	%r28,%r26,%r2
	ldbx	%r19(%r26),%r21
	addl	%r20,%r26,%r3
	stb	%r22,0(%r2)
	comclr,<> %r19,%r28,%r0	; conditional
	copy	%r22,%r21		; move
	dep	%r5,23,8,%r1
	stb	%r29,0(%r3)
	addl	%r22,%r29,%r29
	addl	%r21,%r28,%r28
	and	%r31,%r29,%r29
	and	%r31,%r28,%r28
	ldbx	%r29(%r26),%r2
	ldwx	%r6(%r23),%r5
	ldo	-4(%r25),%r25
	or	%r2,%r1,%r1		; last piece, no need to dep
	vshd	%r4,%r5,%r3		; align data
	copy	%r5,%r4
	xor	%r3,%r1,%r1
	stw	%r1,0(%r23)
	comib,<< 3,%r25,L$oop4misalignedinp
	ldo	4(%r23),%r23
	comib,= 0,%r25,L$done
	nop
	b	L$oop1
	nop

	.ALIGN	8
L$oop4
	ldo	1(%r19),%r20
	
	and	%r31,%r20,%r20
	ldbx	%r28(%r26),%r29
	addl	%r28,%r26,%r2
	ldbx	%r20(%r26),%r22
	addl	%r19,%r26,%r3
	stb	%r21,0(%r2)
	comclr,<> %r20,%r28,%r0	; conditional
	copy	%r21,%r22		; move
	
	stb	%r29,0(%r3)
	addl	%r21,%r29,%r29
	addl	%r22,%r28,%r28
	and	%r31,%r29,%r29
	and	%r31,%r28,%r28
	ldo	1(%r20),%r19
	ldbx	%r29(%r26),%r5
	and	%r31,%r19,%r19
	ldbx	%r28(%r26),%r29
	addl	%r28,%r26,%r2
	ldbx	%r19(%r26),%r21
	addl	%r20,%r26,%r3
	stb	%r22,0(%r2)
	comclr,<> %r19,%r28,%r0	; conditional
	copy	%r22,%r21		; move
	zdep	%r5,7,8,%r1
	stb	%r29,0(%r3)
	addl	%r22,%r29,%r29
	addl	%r21,%r28,%r28
	and	%r31,%r29,%r29
	and	%r31,%r28,%r28
	ldo	1(%r19),%r20
	ldbx	%r29(%r26),%r5
	and	%r31,%r20,%r20
	ldbx	%r28(%r26),%r29
	addl	%r28,%r26,%r2
	ldbx	%r20(%r26),%r22
	addl	%r19,%r26,%r3
	stb	%r21,0(%r2)
	comclr,<> %r20,%r28,%r0	; conditional
	copy	%r21,%r22		; move
	dep	%r5,15,8,%r1
	stb	%r29,0(%r3)
	addl	%r21,%r29,%r29
	addl	%r22,%r28,%r28
	and	%r31,%r29,%r29
	and	%r31,%r28,%r28
	ldo	1(%r20),%r19
	ldbx	%r29(%r26),%r5
	and	%r31,%r19,%r19
	ldbx	%r28(%r26),%r29
	addl	%r28,%r26,%r2
	ldbx	%r19(%r26),%r21
	addl	%r20,%r26,%r3
	stb	%r22,0(%r2)
	comclr,<> %r19,%r28,%r0	; conditional
	copy	%r22,%r21		; move
	dep	%r5,23,8,%r1
	stb	%r29,0(%r3)
	addl	%r22,%r29,%r29
	addl	%r21,%r28,%r28
	and	%r31,%r29,%r29
	and	%r31,%r28,%r28
	ldbx	%r29(%r26),%r2
	ldwx	%r24(%r23),%r4
	ldo	-4(%r25),%r25
	or	%r2,%r1,%r1		; last piece, no need to dep
	xor	%r4,%r1,%r1
	stw	%r1,0(%r23)
	comib,<< 3,%r25,L$oop4
	ldo	4(%r23),%r23
	comib,= 0,%r25,L$done
	nop
L$oop1
	addl	%r28,%r26,%r3
	ldbx	%r28(%r26),%r29
	addl	%r19,%r26,%r2
	stb	%r21,0(%r3)
	ldo	1(%r19),%r19
	stb	%r29,0(%r2)
	addl	%r21,%r29,%r29
	ldbx	%r24(%r23),%r5
	and	%r31,%r29,%r29
	and	%r31,%r19,%r19
	ldbx	%r29(%r26),%r1
	ldbx	%r19(%r26),%r21
	ldo	1(%r23),%r23
	xor	%r5,%r1,%r1
	addl	%r21,%r28,%r28
	stb	%r1,-1(%r23)
	addib,<> -1,%r25,L$oop1	; %r25 is always small
	and	%r31,%r28,%r28
L$done
	ldw	-84(%sp),%r2
	ldo	-1(%r19),%r19	; chill out loop
	sub	%r28,%r21,%r28
	and	%r31,%r19,%r19
	and	%r31,%r28,%r28
	stb	%r19,-2(%r26)
	stb	%r28,-1(%r26)
	ldw	-60(%sp),%r4
	ldw	-56(%sp),%r5
	ldw	-52(%sp),%r6
L$abort
	bv	(%r2)
	.EXIT
	ldwm	-64(%sp),%r3
	.PROCEND

	.EXPORT	RC4_set_key,ENTRY,ARGW0=GR,ARGW1=GR,ARGW2=GR
	.ALIGN	8
RC4_set_key
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	stb	%r0,0(%r26)
	stb	%r0,1(%r26)
	ldo	2(%r26),%r26
	copy	%r0,%r19
L$1st
	stb	%r19,0(%r26)
	ldo	1(%r19),%r19
	bb,>=	%r19,23,L$1st	; %r19<256
	ldo	1(%r26),%r26

	ldo	-256(%r26),%r26	; rewind %r26
	addl	%r25,%r24,%r24		; %r24 to point at the end
	sub	%r0,%r25,%r23		; inverse index
	copy	%r0,%r19
	copy	%r0,%r20
	ldi	0xff,%r31

L$2nd
	ldbx	%r19(%r26),%r21
	ldbx	%r23(%r24),%r22
	addi,nuv 1,%r23,%r23		; increment and conditional
	sub	%r0,%r25,%r23		; inverse index
	addl	%r21,%r20,%r20
	addl	%r22,%r20,%r20
	and	%r31,%r20,%r20
	addl	%r19,%r26,%r29
	ldbx	%r20(%r26),%r22
	addl	%r20,%r26,%r28
	ldo	1(%r19),%r19
	stb	%r21,0(%r28)
	bb,>=	%r19,23,L$2nd	; %r19<256
	stb	%r22,0(%r29)

	bv,n	(%r2)
	.EXIT
	nop
	.PROCEND

	.EXPORT	RC4_options,ENTRY
	.ALIGN	8
RC4_options
	.PROC
	.CALLINFO	NO_CALLS
	.ENTRY
	blr	%r0,%r28
	ldi	3,%r1
L$pic
	andcm	%r28,%r1,%r28
	bv	(%r2)
	.EXIT
	ldo	L$opts-L$pic(%r28),%r28
	.PROCEND
	.ALIGN	8
L$opts
	.STRINGZ "rc4(4x,char)"
	.STRINGZ "RC4 for PA-RISC, CRYPTOGAMS by <appro@openssl.org>"
