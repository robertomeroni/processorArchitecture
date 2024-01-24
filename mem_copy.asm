	.file	"performanceTest.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-1056
	sw	s0,1052(sp)
	addi	s0,sp,1056
	sw	zero,-20(s0)
	j	.L2
.L3:
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	li	a4,5
	sw	a4,-516(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,127
	ble	a4,a5,.L3
	sw	zero,-20(s0)
	j	.L4
.L5:
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-516(a5)
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-1028(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L4:
	lw	a4,-20(s0)
	li	a5,127
	ble	a4,a5,.L5
	nop
	nop
	lw	s0,1052(sp)
	addi	sp,sp,1056
	jr	ra
	.size	_start, .-_start
	.ident	"GCC: () 10.2.0"
