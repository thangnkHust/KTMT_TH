.data  
A:	.word 	1,20,3,-30,5  
.text  
	addi $s1,$zero,0  	# i = 0
	la $s2,A 		# load address A
	addi $s3,$zero,5 	# n = 5 
	addi $s4,$zero,1  	# step = 1
	addi $s5,$zero,0  	# max = 0
loop:  
	slt $t2,$s1,$s3  	# i < n ? 1 : 0
	beq $t2,$zero,endloop  
	add $t1,$s1,$s1  
	add $t1,$t1,$t1  
	add $t1,$t1,$s2  
	lw $t0,0($t1)  
	bgtz $t0, if		# if A[i] > 0 jumb if branch
	sub $t0, $zero, $t0	# abs(A[i])
	#abs $t0,$t0 
if:
	slt $t6,$s5,$t0 
	beq $t6,$zero,endif 
	add $s5,$zero,$t0 
endif: 
	add $s1,$s1,$s4		# i += step 
	j loop  
endloop: 