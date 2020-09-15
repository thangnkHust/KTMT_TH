.data
	Array:	.word 1,4,10,15
	False : .asciiz "False"
	True : .asciiz "True"
.text 
	addi $s0, $0, 0 #i = 0  
	addi $s2, $0, 0
	addi $t0, $0, 3
	lui  $at, 0x1001
	ori  $s1, $at, 0x0020
	
	add  $t4,$t4,$s1
	lw   $s3,0($t4)
	lw   $s4,4($t4)
	slt  $t5,$s3,$s4
	addi $s2,$s2,1
	bne  $t5,$zero, for
	addi $s0,$s0,1
	
for:	slt $t8,$s2,$t0
	beq $t8,$0,true
	sll $t8,$s2,2
	add $t9,$t8, $s1
	lw  $s3,0($t9)
	lw  $s4,4($t9)
	slt $t5,$s3,$s4
	addi $s2,$s2,1
	bne $t5,$zero,for
	addi $s0,$s0,1
	addi $t7,$0,1
	slt $t6,$t7,$s0
	bne $t6,$zero,false
	lw  $s5,-4($t9)
	slt $t6,$s5,$s4
	beq $t6,$zero,false
	j for
false:
	li $v0, 4
	la $a0,False
	syscall 
	
true:
 	li $v0, 4
	la $a0,True
	syscall 
