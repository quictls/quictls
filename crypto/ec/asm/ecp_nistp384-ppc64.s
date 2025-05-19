.machine	"any"
.text

.globl	p384_felem_mul
.align	5
p384_felem_mul:

	vspltisw	0,0

	lxsd	12,0(4)
	lxsd	13,8(4)
	lxsd	14,16(4)
	lxsd	15,24(4)
	lxsd	16,32(4)
	lxsd	17,40(4)
	lxsd	18,48(4)

	lxsd	3,0(5)
	lxsd	4,8(5)
	lxsd	5,16(5)
	lxsd	6,24(5)
	lxsd	7,32(5)
	lxsd	8,40(5)
	lxsd	9,48(5)

	.long	0x126C1823
	stxv	51,0(3)

	xxpermdi	33,44,45,0b00
	xxpermdi	34,36,35,0b00
	.long	0x12611023
	stxv	51,16(3)

	xxpermdi	34,37,36,0b00
	.long	0x12611023
	.long	0x126E1CE3
	stxv	51,32(3)

	xxpermdi	34,36,35,0b00
	xxpermdi	42,46,47,0b00
	xxpermdi	43,38,37,0b00
	.long	0x12615823
	.long	0x126A14E3
	stxv	51,48(3)

	xxpermdi	34,39,38,0b00
	xxpermdi	43,37,36,0b00
	.long	0x12611023
	.long	0x126A5CE3
	.long	0x12701CE3
	stxv	51,64(3)

	xxpermdi	34,40,39,0b00
	xxpermdi	43,38,37,0b00
	.long	0x12611023
	.long	0x126A5CE3
	xxpermdi	43,36,35,0b00
	xxpermdi	33,48,49,0b00
	.long	0x12615CE3
	stxv	51,80(3)

	xxpermdi	33,44,45,0b00
	xxpermdi	34,41,40,0b00
	xxpermdi	43,39,38,0b00
	.long	0x12611023
	.long	0x126A5CE3
	xxpermdi	34,37,36,0b00
	xxpermdi	33,48,49,0b00
	.long	0x126114E3
	.long	0x12721CE3
	stxv	51,96(3)

	xxpermdi	33,45,46,0b00
	xxpermdi	34,41,40,0b00
	xxpermdi	42,47,48,0b00
	.long	0x12611023
	.long	0x126A5CE3
	xxpermdi	42,37,36,0b00
	xxpermdi	33,49,50,0b00
	.long	0x126154E3
	stxv	51,112(3)

	xxpermdi	33,46,47,0b00
	xxpermdi	42,48,49,0b00
	.long	0x12611023
	.long	0x126A5CE3
	.long	0x12722CE3
	stxv	51,128(3)

	xxpermdi	33,47,48,0b00
	.long	0x12611023
	xxpermdi	33,49,50,0b00
	.long	0x12615CE3
	stxv	51,144(3)

	.long	0x126A1023
	.long	0x12723CE3
	stxv	51,160(3)

	.long	0x12611023
	stxv	51,176(3)

	.long	0x12724823
	stxv	51,192(3)
	blr	


.globl	p384_felem_square
.align	5
p384_felem_square:

	vspltisw	0,0

	lxsd	12,0(4)
	lxsd	13,8(4)
	lxsd	14,16(4)
	lxsd	15,24(4)
	lxsd	16,32(4)
	lxsd	17,40(4)
	lxsd	18,48(4)

	li	8,0
	li	9,1
	mtvsrdd	33,9,8
	.long	0x106C0DC4
	.long	0x108D0DC4
	.long	0x10AE0DC4
	.long	0x10CF0DC4
	.long	0x10F00DC4
	.long	0x11110DC4
	.long	0x11320DC4
	.long	0x126C6023
	stxv	51,0(3)

	.long	0x126C2023
	stxv	51,16(3)

	.long	0x126C2823
	.long	0x126D6CE3
	stxv	51,32(3)

	xxpermdi	33,44,45,0b00
	xxpermdi	34,38,37,0b00
	.long	0x12611023
	stxv	51,48(3)

	xxpermdi	43,39,38,0b00
	.long	0x12615823
	.long	0x126E74E3
	stxv	51,64(3)

	xxpermdi	34,40,39,0b00
	.long	0x12611023
	.long	0x126E34E3
	stxv	51,80(3)

	xxpermdi	34,41,40,0b00
	.long	0x12611023
	.long	0x126E3CE3
	.long	0x126F7CE3
	stxv	51,96(3)

	xxpermdi	42,45,46,0b00
	.long	0x126A1023
	.long	0x126F3CE3
	stxv	51,112(3)

	xxpermdi	33,46,47,0b00
	.long	0x12611023
	.long	0x127084E3
	stxv	51,128(3)

	xxpermdi	33,47,48,0b00
	.long	0x12611023
	stxv	51,144(3)

	.long	0x12704823
	.long	0x12718CE3
	stxv	51,160(3)

	.long	0x12714823
	stxv	51,176(3)

	.long	0x12729023
	stxv	51,192(3)
	blr	


