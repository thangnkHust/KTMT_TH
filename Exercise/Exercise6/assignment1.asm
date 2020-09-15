.data
A:	.word -2, 6, -1, 3, -2

.text
main:	la	$a0, A
	li	$a1, 5
	j	mspfx
	nop
continue:
lock:
	j 	lock
	nop
end_of_main:

# proceduce mspfx
mspfx:
	addi	$v0, $zero, 0	# initialize length in $v0 to 0
	addi	$v1, $zero, 0	# initialize max sum in $v1to 0
	addi	$t0, $zero, 0	# initialize index i in $t0 to 0
	addi	$t1, $zero, 0	# initialize running sum in $t1 to 0
loop:
	add 	$t2, $t0, $t0	# put 2i in $t2
	add	$t2, $t2, $t2	# put 4i in $t2
	add 	$t3, $t2, $a0	# put 4i + A(address of A[i])
	lw	$t4, 0($t3)	# load A[i] into $t4
	add	$t1, $t1, $t4	# $t1 = sum += A[i]
	slt	$t5, $v1, $t1
	bne	$t5, $zero, mdfy	# if max sum < new sun
	j	test
mdfy:
	addi 	$v0, $t0, 1
	addi 	$v1, $t1, 0
test:
	addi 	$t0, $t0, 1
	slt	$t5, $t0, $a1
	bne 	$t5, $zero, loop
done:	j 	continue
mspfx_end:
