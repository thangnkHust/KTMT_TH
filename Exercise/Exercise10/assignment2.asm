.eqv MONITOR_SCREEN 	0x10010000
.eqv RED		0x00FF0000
.eqv GREEN		0x0000FF00
.eqv BLUE		0x000000FF
.eqv WHITE 		0x00FFFFFF
.eqv YELLOW		0x00FFFF00
.text
# ---------------------------------------------
# $k0 = $k0 + 32*12*4
# for( y = 12; y < 20; y++)
#	for( x = 0; x < 32; x++)
#		if(11 < x < 20) draw red
#		$k0 += 4
# ---------------------------------------------
	li $k0, MONITOR_SCREEN
	
	addi $t0, $zero, 12	# $t0 = y = 12
	sll $t2, $t0, 2
	addi $k0, $k0, 1536	# $k0 = $k0 + 32*12*4
loop1:
	addi $t1, $zero, 0	# $t1 = x = 0
	slti $t2, $t0, 20
	beqz $t2, end_loop1 
loop2:
	slti $t2, $t1, 32
	beqz $t2, end_loop2
if1:
	sgt $t2, $t1, 11
	beqz $t2, end
if2:	
	slti $t2, $t1, 20
	beqz $t2, end
	li $t3, RED
   	sw  $t3, 0($k0)
end:	
	addi $t1, $t1, 1
	addi $k0, $k0, 4
	j loop2
end_loop2:
	addi $t0, $t0, 1
	j loop1
end_loop1: