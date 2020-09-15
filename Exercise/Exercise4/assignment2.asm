.text
	li $s1, 3
	li $s2, 3		
	slt $t1, $s1, $s2	# ble $s1,s2,L
	bne $t1, $zero, L
	beq $s1, $s2, L
	sub $t0, $s1, $s2
L: 	
	add $t0, $s1, $s2
	
	nor $s0, $s0, $zero	# not $s0
	
	add $s0, $zero, $s1	# move $s0,s1
	
	bgtz $s1, endif		# abs $s0, $s1	
	sub $s0, $zero, $s1
	j endabs
endif:
	add $s0, $zero, $s1
endabs: