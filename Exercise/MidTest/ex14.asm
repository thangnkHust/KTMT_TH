.data
	A: .space 56			# Mang 1	# Tao 1 khong gian trong luu string1
	B: .space 56			# Mang 2	# Tao 1 khong gian trong luu strign2
	C: .word 0:56			# Mang trung gian	# Tao mang temp 
	string_output: .asciiz "So luong ky tu giong nhau la: "
	Nhap1: .asciiz "Nhap xau 1: "
	Nhap2: .asciiz  "Nhap xau 2: "
.text
main:
	# Enter Array A
	li $v0, 54
	la $a0, Nhap1
	la $a1, A
	li $a2, 56
	syscall				# Nhap mang A
	
	# Enter Array B
	li $v0, 54
	la $a0, Nhap2
	la $a1, B
	li $a2, 56
	syscall				# Nhap mang B
	
	la $a0, A 		# gan dia chi string1 vao a0
	jal strLength 			# chuyen den ham strLength
	nop
	add $t6, $zero, $v0		# $t6 la do dai cua string1
	
	la $a0, B 		# gan dia chi string1 vao a0
	jal strLength 			# chuyen den ham strLength
	nop
	add $t7, $zero, $v0		# $t7 la do dai cua string1
	
	# genarate 0 to C
	la $a0, C
	add $t0, $zero, $zero
L3:
	beq $t0, $t7, end_L3	#thoat khoi vong lap khi i = do dai cua mang
	sll $t1, $t0, 2
	add $t1, $t1, $a0	#add dia chi A[i] vao $t1
	sw $zero, 0($t1)		#A[i] = 0
	addi $t0, $t0, 1 	#i++
	j L3
end_L3:

	la $s0, A
	la $s1, B
	la $s2, C
	add $t3, $s0, $zero		# $t3 = Address of A
	
	addi $s3, $zero, 0		# count = 0
	
	addi $t0, $zero, 0		# $t0 = i = 0 of loop1
loop1:
	sge $t2, $t0, $t6		# if i >= 5 then jump end_loop1
	bnez $t2, end_loop1
	
	addi $t1, $zero, 0		# $t1 = j = 0 of loop2
	
	add $t4, $s1, $zero		# $t4 = Address of B
	add $t5, $s2, $zero		# $t5 = Address of C
loop2:
	sge $t2, $t1, $t7		# if i >= 6 then jump end_loop2
	bnez $t2, end_loop2
if:
	lb $s4, 0($t3)			# $s4 = A[i]
	lb $s5, 0($t4)			# $s5 = B[j]
	lw $s6, 0($t5)			# $s6 = C[j]
	seq $t2, $s4, $s5		# if A[i] = B[j]
	beqz $t2, end_if		# then true
	bnez $s6, end_if		# if C[j] = 0 then true
	addi $s3, $s3, 1		# count++
	addi $s6, $zero, 1		
	sw $s6, 0($t5)			# C[j] = $s6 = 1
	j end_loop2
end_if:
	addi $t1, $t1, 1		# j++
	addi $t4, $t4, 1		# Get address of B[j]
	addi $t5, $t5, 4		# Get address of C[j]
	j loop2
end_loop2:
	addi $t0, $t0, 1		# i++
	addi $t3, $t3, 1		# Get address of A[i]
	j loop1
end_loop1:
end_main:
	li $v0, 56			# output count
	la $a0, string_output
	add $a1, $s3, $zero
	syscall
	
	li $v0, 10
	syscall

#Funtion strLength

strLength:

	add $v0, $zero, $zero  		#i=0
L1:
	add $t1, $v0, $a0		
	lb $t2, 0($t1)
	beq $t2, 10, end_strLength 
	addi $v0, $v0, 1
	j L1
end_strLength:
	jr $ra
	

