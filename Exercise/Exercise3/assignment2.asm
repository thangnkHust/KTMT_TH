.data 
A:	.word 	3,2,4,0,5
.text
	li $s1, 0	# i = 0
	la $s2, A	# gan dia chi dau mang A cho $s2
	li $s3, 5	# n = 5
	li $s4, 1	# step = 1
	li $s5, 0	# sum = 0
loop: 
	sgt $t2, $s1, $s3	# $t2 = i > n ? 1 : 0
	bne $t2, $zero, endloop
	add $t1,$s1,$s1		#$t1=2*$s1
	add $t1,$t1,$t1		#$t1=4*$s1
	add $t1,$t1,$s2		#$t1 store the address of A[i]
	lw  $t0,0($t1)		#load value of A[i] in $t0
	#beq $t0, $zero, endloop	# A[i] == 0 --> endloop
	add $s5,$s5,$t0		#sum=sum+A[i]
	add $s1,$s1,$s4		#i=i+step
	#bltz $s5, endloop	# neu sum < 0 thi endloop
	
	j loop			#goto loop
endloop:
	# i > n thi endloop
