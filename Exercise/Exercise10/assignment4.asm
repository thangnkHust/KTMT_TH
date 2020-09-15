.eqv KEY_CODE 0xFFFF0004 	# ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000	# =1 if has a new keycode ?
				# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C 	# ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008	# =1 if the display has already to do
				# Auto clear after sw
.text
	li $k0, KEY_CODE 
	li $k1, KEY_READY
	li $s0, DISPLAY_CODE 
	li $s1, DISPLAY_READY
loop:	nop

WaitForKey:
	lw $t1, 0($k1)			# $t1 = [$k1] = KEY_READY
	beq $t1, $zero, WaitForKey	# if $t1 == 0 then Polling
ReadKey:
	lw $t0, 0($k0)			# $t0 = [$k0] = KEY_CODE
WaitForDis:
	lw $t2, 0($s1)			# $t2 = [$s1] = DISPLAY_READY
	beq $t2, $zero, WaitForDis	# if $t2 == 0 then Polling

	beq	$t0, 'e', check_e
	beq	$t0, 'x', check_x
	beq	$t0, 'i', check_i
	beq	$t0, 't', check_t
	j	skip_checking
Encrypt:
	addi $t0, $t0, 1		# change input key
ShowKey:
	sw $t0, 0($s0)			# show key
	nop
	j loop

check_e:
	bne	$s2, $zero, skip_checking
	addi	$s2, $zero, 1		#wait for x
	j	Encrypt

check_x:
	addi	$t3, $zero, 1
	bne	$s2, $t3, skip_checking
	addi	$s2, $zero, 2		#wait fro i	
	j	Encrypt	
	
check_i:
	addi	$t3, $zero, 2
	bne	$s2, $t3, skip_checking
	addi	$s2, $zero, 3		#wait fro t	
	j	Encrypt

check_t:
	addi	$t3, $zero, 3
	bne	$s2, $t3, skip_checking
	li	$v0, 10			#terminate the program if get 'exit'
	syscall
	
skip_checking:
	addi	$s2, $zero, 0
	j	Encrypt
	nop