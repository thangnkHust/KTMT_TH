.data
A: 	.word 	7, -2, 5, 1, 5,6,7,3,6,8,8,59,5
.text
main: 
    la $a0,A    #$a0 = Address(A[0])
    li $s0, 13  #length of array $s0,  length 
    j sort      #sort
after_sort: 
    li $v0, 10 #exit
    syscall
end_main:



#Bubble sort algorithm
sort:
    	li $t0, 0   # $t0 = i = 0
loop1:
     	slt $v0, $t0, $s0      # set $v0 = 1 when i < length
    	beq $v0, $zero, end_loop1   # end loop when i >= length
    	li 	$t1, 0   	# $t1 = j = 0
loop2:
	addi	$t2, $s0, -1
	sub	$t2, $t2, $t0	# $t2 = temp = n-i-1 
	slt 	$v0, $t1, $t2     # set $v0 = 1 when j < temp
    	beq	$v0, $zero, end_loop2
if:
    	sll 	$t5, $t1, 2	# $t5 = 4*j
    	add 	$t5, $t5, $a0	# $t5 is address A[j]
    	lw 	$t3, 0($t5)    	# Load $t3 = A[j]
    	lw	$t4, 4($t5)	# $t4 = A[j+1]
    	sgt 	$v0, $t3, $t4   # set $v0 = 1 when A[j] > A[j+1]
    	beq 	$v0, $zero, end_if   # End_if if A[j] <= A[j+1]
    	j 	swap
end_if:
	addi 	$t1, $t1, 1	# j++
    	j 	loop2
end_loop2:
    	addi	$t0, $t0, 1	# i++
    	j 	loop1
end_loop1:
	j	after_sort
swap:
	sw	$t4, 0($t5)
	sw	$t3, 4($t5)
	j	end_if   