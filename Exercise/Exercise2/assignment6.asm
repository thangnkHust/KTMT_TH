# Exercise 2 - Assignment 6
.data
X:	.word	5
Y:	.word	-1
Z: 	.word

.text
	# Load X, Y to registers
	la	$t8, X		# load adress of X to $t8
	la	$t9, Y
	lw	$t1, 0($t8)	# $t1 = X
	lw	$t2, 0($t9)	# $t2 = Y
	
	# Calculate expression Z = 2X + Y
	add	$s0, $t1, $t1
	add	$s0, $s0, $t2
	
	# Store result from register to variable Z
	la	$t7, Z
	sw	$s0, 0($t7)