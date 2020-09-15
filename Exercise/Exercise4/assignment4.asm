.text
	addi $s1, $zero, 0xffffffff
	addi $s2, $zero, 0x80000000
	li $t0, 0		# No overflow is default status
	addu $s3, $s1, $s2
	xor $t1, $s1, $s2	# check $s1, $s2 have the same sign
	
	bltz $t1, EXIT
	
	xor $t1, $s1, $s3	# check $s1, $s3 have the same sign
	bgtz $t1, EXIT

OVERFLOW:
	li $t0, 1

EXIT:
