	.file	"performanceTest.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	li	t1,-196608
	add	sp,sp,t1
	sw	zero,-20(s0)
	j	.L2
.L7:
	sw	zero,-24(s0)
	j	.L3
.L6:
	li	a5,-196608
	addi	a4,s0,-16
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a3,a5,7
	lw	a5,-24(s0)
	add	a5,a3,a5
	slli	a5,a5,2
	add	a5,a4,a5
	sw	zero,-12(a5)
	sw	zero,-28(s0)
	j	.L4
.L5:
	li	a5,-196608
	addi	a4,s0,-16
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a3,a5,7
	lw	a5,-24(s0)
	add	a5,a3,a5
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a4,-12(a5)
	li	a5,-65536
	addi	a3,s0,-16
	add	a3,a3,a5
	lw	a5,-20(s0)
	slli	a2,a5,7
	lw	a5,-28(s0)
	add	a5,a2,a5
	slli	a5,a5,2
	add	a5,a3,a5
	lw	a3,-12(a5)
	li	a5,-131072
	addi	a2,s0,-16
	add	a2,a2,a5
	lw	a5,-28(s0)
	slli	a1,a5,7
	lw	a5,-24(s0)
	add	a5,a1,a5
	slli	a5,a5,2
	add	a5,a2,a5
	lw	a5,-12(a5)
	mul	a5,a3,a5
	add	a4,a4,a5
	li	a5,-196608
	addi	a3,s0,-16
	add	a3,a3,a5
	lw	a5,-20(s0)
	slli	a2,a5,7
	lw	a5,-24(s0)
	add	a5,a2,a5
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a4,-12(a5)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L4:
	lw	a4,-28(s0)
	li	a5,127
	ble	a4,a5,.L5
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L3:
	lw	a4,-24(s0)
	li	a5,127
	ble	a4,a5,.L6
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,127
	ble	a4,a5,.L7
	nop
	nop
	li	t1,196608
	add	sp,sp,t1
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	_start, .-_start
	.ident	"GCC: () 10.2.0"
