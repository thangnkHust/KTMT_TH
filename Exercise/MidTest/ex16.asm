.data
	Array:	.word 	0:100
	Number: .asciiz "Number of array: "
	Element: .asciiz "Enter value: "
	False : .asciiz "False"
	True : .asciiz "True"
	Error1: .asciiz "Input data cannot be correctly parse"
	Error2: .asciiz "Cancel was chosen"
	Error3: .asciiz "OK was chosen but no data had been input into field"
	Error4: .asciiz "Number of array must not equal zero"
.text
main:
	addi $s0, $zero, 0		# foundOne = false

	li $v0, 51
	la $a0, Number
	syscall
	
	beq $a1, -1, error1
	beq $a1, -2, error2
	beq $a1, -3, error3
	beqz $a0, error4
	j input_array
error1:
	li $v0, 55
	la $a0, Error1
	li $a1, 0
	syscall
	j main
error2:
	li $v0, 55
	la $a0, Error2
	li $a1, 0
	syscall
	j main
error3:
	li $v0, 55
	la $a0, Error3
	li $a1, 0
	syscall
	j main
error4:
	li $v0, 55
	la $a0, Error4
	li $a1, 0
	syscall
	j main

input_array:	
	add $s2, $zero, $a0		# set length = $a0 into $s2
	
	addi $t0, $zero, 0		# $t0 = i = 0
	la $s1, Array			# $s1 = Address of Array
enter_array:	
	slt $t1, $t0, $s2		# if i < length then true
	beqz $t1, end_array
	
	# Enter 1 element of array
	li $v0, 51
	la $a0, Element
	syscall
	
	beq $a1, -1, element_error1
	beq $a1, -2, element_error2
	beq $a1, -3, element_error3
	j start
element_error1:
	li $v0, 55
	la $a0, Error1
	li $a1, 0
	syscall
	j enter_array
element_error2:
	li $v0, 55
	la $a0, Error2
	li $a1, 0
	syscall
	j enter_array
element_error3:
	li $v0, 55
	la $a0, Error3
	li $a1, 0
	syscall
	j enter_array

start:
	sw $a0, 0($s1)
	
	addi $s1, $s1, 4
	addi $t0, $t0, 1
	j enter_array
end_array:
	la $s1, Array			# $s1 = Adress of Array
	addi $t0, $zero, -1		# $t0 = i = -1
	addi $t1, $zero, 0		# $t1 = j = 0
	addi $t2, $zero, 1		# $t2 = k = 1
loop:
	sge $t7, $t2, $s2
	bnez $t7, end_main
	addi $t3, $s1, 0		# $t3 = Address of Array
	addi $s3, $zero, 0		# set deleteCurrent = false
if1:
	sll $t4, $t0, 2			# 4*i
	sll $t5, $t1, 2			# 4*j
	sll $t6, $t2, 2			# 4*k
	add $t5, $t3, $t5
	lw $t5, 0($t5)			# $t5 = A[j]
	add $t6, $t3, $t6
	lw $t6, 0($t6)			# $t6 = A[k]
	
	slt $t7, $t5, $t6		# if A[j] < A[k]		
	bnez $t7, if2			# jump to if2
	bnez $s0, false
	li $s0, 1
	blt $t2, 2, if2
	add $t4, $t3, $t4
	lw $t4, 0($t4)			# $t4 = A[i]
	slt $t7, $t4, $t6
	bnez $t7, if2
	addi $s3, $zero, 1		# deleteCurrent = true
if2:
	bnez $s0, if3
	add $t0, $zero, $t1
if3:
	bnez $s3, end_loop
	add $t1, $zero, $t2
end_loop:
	addi $t2, $t2, 1		# k++
	j loop
end_main:
	j true
false:
	li $v0, 55
	la $a0,False
	syscall 
	
	li $v0, 10
	syscall
	
true:
 	li $v0, 55
	la $a0,True
	li $a1, 1
	syscall 
