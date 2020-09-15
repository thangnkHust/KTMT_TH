# Exercise 3 - Assignment 1
.data

.text
	addi $s1, $zero, 1	# i = 1
	addi $s2, $zero, 2	# j = 2
	addi $s3, $zero, 1	# m = 1
	addi $s4, $zero, -3	# n = -3	
if:
	add $t0, $s1, $s2	# $t0 = i + j
	add $t4, $s3, $s4	# $t4 = m + n
	ble $t0, $t4, else	# $to <= $t4 jumb to else branch
	#bgtz $t0, else		# $t0 > 0 jumb to else branch
	#slt $t0, $s1, $s2	# i < j
	#bne $t0, $zero, else	# branch to else if j<i
	#bge $s1, $s2, else	# i >= j
	addi $t1, $t1, 1		# then part: x=x+1
	addi $t3, $zero, 1	# z = 1
	j endif			# skip “else” part
else:
	addi $t2,$t2,-1		# begin else part: y=y-1
	add $t3,$t3,$t3 	# z=2*z
endif: