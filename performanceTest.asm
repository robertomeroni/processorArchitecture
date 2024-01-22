buffer_sum:
        addi    sp,sp,-544
        sw      s0,540(sp)
        addi    s0,sp,544
        sw      zero,-20(s0)
        sw      zero,-24(s0)
        j       .L2
.L3:
        lw      a5,-24(s0)
        slli    a5,a5,2
        addi    a5,a5,-16
        add     a5,a5,s0
        lw      a5,-520(a5)
        lw      a4,-20(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L2:
        lw      a4,-24(s0)
        li      a5,127
        ble     a4,a5,.L3
        nop
        nop
        lw      s0,540(sp)
        addi    sp,sp,544
        jr      ra
mem_copy:
        addi    sp,sp,-1056
        sw      s0,1052(sp)
        addi    s0,sp,1056
        sw      zero,-20(s0)
        j       .L5
.L6:
        lw      a5,-20(s0)
        slli    a5,a5,2
        addi    a5,a5,-16
        add     a5,a5,s0
        li      a4,5
        sw      a4,-516(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L5:
        lw      a4,-20(s0)
        li      a5,127
        ble     a4,a5,.L6
        sw      zero,-20(s0)
        j       .L7
.L8:
        lw      a5,-20(s0)
        slli    a5,a5,2
        addi    a5,a5,-16
        add     a5,a5,s0
        lw      a4,-516(a5)
        lw      a5,-20(s0)
        slli    a5,a5,2
        addi    a5,a5,-16
        add     a5,a5,s0
        sw      a4,-1028(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L7:
        lw      a4,-20(s0)
        li      a5,127
        ble     a4,a5,.L8
        nop
        nop
        lw      s0,1052(sp)
        addi    sp,sp,1056
        jr      ra
matrix_multiply:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        li      t0,-196608
        add     sp,sp,t0
        sw      zero,-20(s0)
        j       .L10
.L15:
        sw      zero,-24(s0)
        j       .L11
.L14:
        li      a5,-196608
        addi    a5,a5,-16
        add     a4,a5,s0
        lw      a5,-20(s0)
        slli    a3,a5,7
        lw      a5,-24(s0)
        add     a5,a3,a5
        slli    a5,a5,2
        add     a5,a4,a5
        sw      zero,-12(a5)
        sw      zero,-28(s0)
        j       .L12
.L13:
        li      a5,-196608
        addi    a5,a5,-16
        add     a4,a5,s0
        lw      a5,-20(s0)
        slli    a3,a5,7
        lw      a5,-24(s0)
        add     a5,a3,a5
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,-12(a5)
        li      a5,-65536
        addi    a5,a5,-16
        add     a3,a5,s0
        lw      a5,-20(s0)
        slli    a2,a5,7
        lw      a5,-28(s0)
        add     a5,a2,a5
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a3,-12(a5)
        li      a5,-131072
        addi    a5,a5,-16
        add     a2,a5,s0
        lw      a5,-28(s0)
        slli    a1,a5,7
        lw      a5,-24(s0)
        add     a5,a1,a5
        slli    a5,a5,2
        add     a5,a2,a5
        lw      a5,-12(a5)
        mul     a5,a3,a5
        add     a4,a4,a5
        li      a5,-196608
        addi    a5,a5,-16
        add     a3,a5,s0
        lw      a5,-20(s0)
        slli    a2,a5,7
        lw      a5,-24(s0)
        add     a5,a2,a5
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,-12(a5)
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L12:
        lw      a4,-28(s0)
        li      a5,127
        ble     a4,a5,.L13
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L11:
        lw      a4,-24(s0)
        li      a5,127
        ble     a4,a5,.L14
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L10:
        lw      a4,-20(s0)
        li      a5,127
        ble     a4,a5,.L15
        nop
        nop
        li      t0,196608
        add     sp,sp,t0
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
