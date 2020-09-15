.text
	li $s0, 1		# $s0 = 1
	li $t0, 2		# n = 2
	sllv $s1, $s0, $t0		# $s1 = 2^2
	sll $s2, $s0, 4		# $s2 = 2^4
	sll $s3, $s0, 8		# $s3 = 2^8
	sll $s4, $s0, 16	# $s4 = 2^16