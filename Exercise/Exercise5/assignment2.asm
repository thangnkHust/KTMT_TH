# Assignment 2 - Exercise 5
.data
	t1: .asciiz "\nThe sum of ("
	t2: .asciiz ") and ("
	t3: .asciiz ") is ("
	t4: .asciiz ")\n"
.text 
	li $s0, 50        	# $s0 = 50
	li $s1, 90      	# $s1 = 90
	add $s2, $s0, $s1   	# $s2 = $s1 + $s0
	li $v0, 4
	la $a0, t1
	syscall
	
	li $v0, 1
	add $a0,$zero, $s0 
	syscall         	# print $s0
	
	li $v0, 4
	la $a0, t2
 	syscall

	li $v0, 1
 	add $a0,$zero, $s1
 	syscall         	# print $s1

 	li $v0, 4
	la $a0, t3
	syscall         

 	li $v0, 1
	add $a0,$zero, $s2
	syscall         	# print $s2

	li $v0, 4
	la $a0, t4
	syscall

