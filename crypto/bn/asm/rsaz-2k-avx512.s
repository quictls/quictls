.text	

.globl	ossl_rsaz_avx512ifma_eligible
.type	ossl_rsaz_avx512ifma_eligible,@function
ossl_rsaz_avx512ifma_eligible:
	xorl	%eax,%eax
	.byte	0xf3,0xc3
.size	ossl_rsaz_avx512ifma_eligible, .-ossl_rsaz_avx512ifma_eligible

.globl	ossl_rsaz_amm52x20_x1_ifma256
.globl	ossl_rsaz_amm52x20_x2_ifma256
.globl	ossl_extract_multiplier_2x20_win5
.type	ossl_rsaz_amm52x20_x1_ifma256,@function
ossl_rsaz_amm52x20_x1_ifma256:
ossl_rsaz_amm52x20_x2_ifma256:
ossl_extract_multiplier_2x20_win5:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3
.size	ossl_rsaz_amm52x20_x1_ifma256, .-ossl_rsaz_amm52x20_x1_ifma256
