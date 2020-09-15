.text
main:
	li $s0,-34		# load data into $s0 -> $s7
	li $s1,-33
	li $s2,6
	li $s3,-2
	li $s4,-9
	li $s5,100
	li $s6,4
	li $s7,-1

	li $t1,1		# init position into $t1, $t2, $t3
	li $t2,1
	li $t3,1
	jal init
	nop
	li $t4,9
	sub $a0,$t4,$t2		# positon of max
	sub $a1,$t4,$t3		# position of min
	j end
	nop
endmain:
init:
	add $v0,$s7,$zero	# assign max = $v0 = $s7
	add $v1,$s7,$zero	# assign min = $v1 = $s7
push:
	addi $sp,$sp,-32	# allocate space for $s0->$s7 in stack
	sw $s0,28($sp)
	sw $s1,24($sp)
	sw $s2,20($sp)
	sw $s3,16($sp)
	sw $s4,12($sp)
	sw $s5,8($sp)
	sw $s6,4($sp)
	sw $s7,0($sp)
pop:
	addi $sp,$sp,4		# Nhay xuong 1 o nho trong stack
	lw $a1,0($sp)		# $a1 = current_value
	addi $t1,$t1,1
	sub $t0,$a1,$v0
	bltz $t0,okay1		# if $a0 < max --> jump okay1
	nop
	add $v0,$a1,$zero	# else --> max = $v0 = $a1
	add $t2,$t1,$zero	# $t2 = position of max 
okay1:
	sub $t0,$a1,$v1		
	bgtz $t0,okay2		# if $a1 > min jump okay2
	nop
	add $v1,$a1,$zero	# else min = $v1 = $a1
	add $t3,$t1,$zero	# $t3 = position of min
okay2:
	bne $a1,$s0,pop		# loop while $a1 != $s0
	nop
done:
	jr $ra			# continue main
	# Largest: $v0,$a0
	# Smallest: $v1,$a1
end: