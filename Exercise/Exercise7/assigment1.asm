#Laboratory Exercise 7 Home Assignment 1
.text
main:
	li $a0,-12		# load input parameter
	jal abs			# jump and link abs proceduce
	nop
	add $s0, $zero, $v0
	li $v0,10		# terminate
	syscall
endmain:

abs:
	sub $v0,$zero,$a0
	bltz $a0,done
	nop
	add $v0,$a0,$zero
done:
	jr $ra

	#Result at $s0