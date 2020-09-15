.data
	buffer: .space 50
.text
    	li $s6, 20  # Max length
    	li $s7, 10  # ASCII code of '\n'
	la $s0, buffer  # Load buffer
	li $s1, 0   # index = 0
	li $s3, 0   # i = 0
start_read_char:
    	li $v0, 12
    	syscall     # Read char
	add $s1, $s0, $s3   # Load buffer[i] $s1 = buffer[0] + i
					#	 = address of buffer[i]
	addi $s3, $s3, 1    # i++
	sb $v0, 0($s1)
	beq $s3, $s6, end_read_char #   exit when max length
	beq $v0, $s7, end_read_char #   exit when enter
	
	j start_read_char
end_read_char:
Print_the_reverse_string:
	li $v0, 11
	lb $a0, 0($s1)
	syscall
	beq $s1, $s0, exit
	addi $s1, $s1, -1
	j Print_the_reverse_string	
exit:

