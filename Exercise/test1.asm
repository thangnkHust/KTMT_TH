.data
	N: .asciiz "Nguyen Khac Thang"
	M: .word -2,3,-4,5,-6,-7,-8	
.text
	li $t2, 2
	li $t3, 3
	mul $t1, $t2, $t3
	
	la 	$s0, 0x12345678
	lw 	$t0, 0($s0)
	sw 	$t0, 0x10010040
	lb	$t1, 0($s0)
	
	
	addi	$s5, $0, 7
	addi	$v0, $0, 0			# 0x00407000
	addi	$s1, $0, 0			#                   4
loop:	
	slt	$t0, $s1, $s5			
	beq	$t0, $0, finish
	sll	$t1, $s1, 2
	add	$t2, $s0, $t1
	lw	$t0, 0($t2)
	
	addi 	$s1, $s1, 1
	
	slt	$t3, $t0, $0
	beq	$t3, $0, loop
	add	$v0, $v0, $t0
	j	loop				# 0x00407018
finish:	
