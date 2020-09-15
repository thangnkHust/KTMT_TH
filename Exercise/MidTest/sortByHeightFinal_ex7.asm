#--------------------------------------------------------------------------------------------------------------------
# Project 7: sortByHeight
#
# Task: Some people are standing in a row in a park. There are trees between them which cannot be moved. 
#	Your task is to rearrange the people by their heights in a non- descending order without moving the trees. 
#	People can be very tall!
#
# Example: For a = [-1, 150, 190, 170, -1, -1, 160, 180]
#	   the output should be sortByHeight(a) = [-1, 150, 160, 170, -1, -1, 180, 190].
#---------------------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------------------
# Summary
#
# @input: A (input array)
# @note: -1 represent trees 
# height: store height of person in input array
# @idea: Input array 
# 	1. @find_height: find height of person in A array => store result in 'height' array
#	2. @sort_height: sort the 'height' array in ascending order 
#	3. @replace: replace values in A array by a value in 'height' arrays
#---------------------------------------------------------------------------------------------------------------------

.data
	# Input array
	message: .asciiz "Enter length of input array: "
	message1: .asciiz "Enter element of input array: "
	message_error1: .asciiz "Input type error! Please enter integer input!"
	message_error2: .asciiz "Cancel was choosen! Please enter integer input!"
	message_error3: .asciiz "No data was input! Please enter integer input!"
	message_done: .asciiz "Sorted array: "
	blank: .asciiz " "
	message_error: .ascii "Error input type!!! Please enter integer number!"
	A: .word 0:100			# input array
	height: .word 			# array to store height of each person
	
.text
main:
	# constructor Array
	li $v0, 51			# InputDialogInt
	la $a0, message
	syscall		
	
	addi 	$t5, $zero, -1		# t5 = -1: input error
	addi	$t6, $zero, -2		# t6 = -2: cancel error
	addi	$t7, $zero, -3		# t7 = -3: no data input error	
	
	add 	$s6, $zero, $a1		# s6 = a1 = status value of InputDialogInt
								# if s6 == 0: OK
								# if s6 == -1: input error -> need handle
	
	beq	$s6, $t5, output_error1 # input type error
	beq	$s6, $t6, output_error2	# cancel error
	beq	$s6, $t7, output_error3	# no data input error
	
	add 	$t8, $a0, $zero		# $t8 = length of input array
	
	li 	$t0, 0					# $t0 = i = 0
	la 	$t2, A					# load address of A array
	
loop:
	# Get input array from user
	slt 	$t1, $t0, $t8		# if i < length
	beqz 	$t1, end_loop 
	
	li 	$v0, 51					# InputDialogInt
	la 	$a0, message1
	syscall
	
	add 	$s6, $zero, $a1		# s6 = a1 = status value of InputDialogInt
								# if s6 == 0: OK
								# if s6 == -1: input error -> need handle
	beq	$s6, $t5, error1 		# input type error
	beq	$s6, $t6, error2		# cancel error
	beq	$s6, $t7, error3		# no data input error
	
	sw 		$a0, 0($t2)			# save value of element in A[i]
	addi 	$t2, $t2, 4
	addi 	$t0, $t0, 1
	j loop

end_loop:
	
	la 		$a0, A				# load address of A array
	la 		$a1, height 		# load address of height array
	addi 	$s0, $zero, -1		# -1: represent tree in 'A' array
	add 	$s1, $zero, $t8		# n: length of 'A' array
	addi 	$s2, $zero, 0		# m: lenght of 'height' array
	
	j find_height
	
after_find_height:
	j sort_height

after_sort:
	j replace

after_replace:
	li $t0, 0					# $t0 = i = 0
	la $t2, A					# load address of A array
	
	li $v0, 4
	la $a0, message_done		# print stringn output
	syscall

output:
loop_output:
	slt $t1, $t0, $t8			# if i < length
	beqz $t1, end_loop_output
	
	li $v0, 1					# InputDialogInt
	lw $a0, 0($t2)				# save value of element in A[i]
	syscall
	
	li $v0, 4
	la $a0, blank				# print blank
	syscall
	
	addi $t2, $t2, 4			# next element in A
	addi $t0, $t0, 1			# i = i + 1
	j loop_output
	
end_loop_output:
	li $v0, 10					# terminate
	syscall
	
output_error1:
	li $v0, 55
	li $a1, 2					# warning message
	la $a0, message_error1 
	syscall
	
	j main	

output_error2:
	li $v0, 55
	li $a1, 2					# warning message
	la $a0, message_error2 
	syscall
	
	j main
	
output_error3:
	li $v0, 55
	li $a1, 2					# warning message
	la $a0, message_error3 
	syscall
	
	j main

error1:
	li $v0, 55
	li $a1, 2					# warning message
	la $a0, message_error1
	syscall
	
	j loop

error2:
	li $v0, 55
	li $a1, 2					# warning message
	la $a0, message_error2
	syscall
	
	j loop

error3:
	li $v0, 55
	li $a1, 2					# warning message
	la $a0, message_error3
	syscall
	
	j loop
end_output:
end_main:
	
	
#-----------------------------------------------------------
# 1. @find_height: find height of person in A array => store result in 'height' array
#    @input: A array (input array)
#    @output: 'height' array
#-----------------------------------------------------------

find_height:

	# initialize i, j 
	addi 	$t0, $zero, 0		# i = 0
	addi 	$t2, $zero, 0		# j = 0

fh_loop:
	sll  	$t1, $t0, 2			# $t1 = 4*i
	add  	$t1, $t1, $a0		# $t1 stores address of A[i]
	lw   	$s3, 0($t1)			# load value of A[i]
	
	beq  	$s3, $s0, fh_continue	# if A[i] == -1 => continue (ignore tree)
	
	sll  	$t3, $t2, 2			# $t3 = 4*j
	add  	$t3, $t3, $a1		# $t3 store address of height[j]
	sw   	$s3, 0($t3)			# store value of height[j] in $s3
	addi 	$t2, $t2, 1			# j = j + 1
	addi 	$s2, $s2, 1			# m = m + 1 (increase number of elements in 'height' array)
	
fh_continue:
	addi 	$t0, $t0, 1		# i = i + 1
	slt  	$t4, $t0, $s1	# if i < n => True: return 1; False: return 0
	bne  	$t4, $zero, fh_loop 

fh_end_loop:
	j after_find_height

#### Sort 'height' array in ascending order using BubbleSort

#---------------------------------------------------------------------------------------------------------------------
# 2. @sort_height: Sort 'height' array in ascending order
# @input: height - random order
# @output: height - sorted in ascending order
#---------------------------------------------------------------------------------------------------------------------

sort_height:

	# Initialize index i of loop_1 to 0
	addi 	$t0, $zero, 0		# i = 0
	
loop_1:
	# Initialize index j of loop_2 to 0
	addi  	$t1, $zero, 0		# j = 0
	
	addi 	$t0, $t0, 1			# i = i + 1
	sub 	$t2, $s2, $t0		# m - i - 1
	
	# If i < m - 1
	slt 	$t6, $t0, $s2  
	beq 	$t6, $zero, end_loop_1
	
loop_2:
	# If j < m - i - 1
	slt 	$t5, $t1, $t2		#  j < m - i - 1: True return 1; else return 0 
	beq 	$t5, $zero, end_loop_2

	sll 	$t3, $t1, 2 		# $t3 = 4*j
	add 	$t3, $t3, $a1		# $t3 stores address of height[j]
	lw  	$s3, 0($t3)		# load value of height[j] to $s3
	lw  	$s4, 4($t3)		# load value of height[j+1] to $s4
	
if:
	slt	 $t4, $s3, $s4 		# if A[j] < A[j+1] => True: return 1; False: return 0
	bne 	$t4, $zero, end_if
	
	# If height[j] > height[j + 1] => Swap height[j] and height[j+1]	
   	sw 	$s4, 0($t3) 
    sw 	$s3, 4($t3) 

end_if:
	addi 	$t1, $t1, 1		# j = j + 1
	j   	loop_2
	
end_loop_2:
	j   	loop_1
	
end_loop_1:
	j 	after_sort

#---------------------------------------------------------------------------------------------------------------------
# 3. @replace: replace values in A array by a value in 'height' array
# @input: A (input array)
# @output: A (sorted input array in ascending order)
# @note: Reset values of 'height' array = 0 
#---------------------------------------------------------------------------------------------------------------------

replace:
	# Initialize i, j 
	addi 	$t0, $zero, 0		# i = 0
	addi 	$t2, $zero, 0		# j = 0
	
i_loop:
	sll  	$t1, $t0, 2			# $t1 = 4*i
	add  	$t1, $t1, $a0		# $t1 stores address of A[i]
	lw   	$s3, 0($t1)			# load address of A[i]
	
	beq  	$s3, $s0, i_continue	# if A[i] == -1 => continue
	
	sll  	$t3, $t2, 2			# $t3 = 4*j
	add  	$t3, $t3, $a1		# $t3 stores address of height[j]
	lw   	$s3, 0($t3)			# load value of height[j]
	sw 	$s3, 0($t1)				# A[i] = height[j]
	
	addi 	$s4, $zero, 0
	sw 	$s4, 0($t3)		# Reset value0 of height[j] = 0
	addi 	$t2, $t2, 1		# j = j + 1

i_continue:
	addi 	$t0, $t0, 1		# i = i + 1
	slt  	$t4, $t0, $s1		# if i < n: True return: 1; False return: 0
	bne  	$t4, $zero, i_loop 

i_end_loop:
	j 	after_replace

#---------------------------------------------------------------------------------------------------------------------
# END
#---------------------------------------------------------------------------------------------------------------------
