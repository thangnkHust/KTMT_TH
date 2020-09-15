.text
	li $s0, 0x01020304
	andi $t0, $s0, 0xff000000	# Extra MSB 
	andi $t1, $s0, 0xffffff00	# Clear LSB
	or $t2, $s0, 0x000000ff		# Set LSB of $s0 (bits 7 to 0 are set to 1)
	xor $t3, $s0, $s0		# Clear $s0