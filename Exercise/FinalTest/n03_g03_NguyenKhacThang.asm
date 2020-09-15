# MMIO Simulator
.eqv KEY_CODE		0xFFFF0004
.eqv KEY_READY		0xFFFF0000
.eqv DISPLAY_CODE 	0xFFFF000C 	# ASCII code to show, 1 byte
.eqv DISPLAY_READY 	0xFFFF0008 	# =1 if the display has already to do
 					# Auto clear after sw
# Led 7 doan			
.eqv SEVENSEG_RIGHT 	0xFFFF0010 	# Dia chi cua den led 7 doan phai
.eqv SEVENSEG_LEFT	0xFFFF0011 	# Dia chi cua den led 7 doan trai

.eqv LIMIT_TIME		200000		# Gioi han thoi gian 200000 chu ki ngat

.data
	string: .asciiz "hello nhom 3 nguyen khac thang"
	buffer: .space 100
	count_true: .asciiz "\nso ky tu dung la: "
	speed: .asciiz "\ntoc do: "
	don_vi: .asciiz " time/char"

.text
	li $t0, 1			
	sb $t0, 0xFFFF0013($zero)	# Set bit tai 0xFFFF0013 khac 0 de kich hoat ngat
					# Sau 30 cau lenh se ngat 1 lan						
	li $t0, 0			# Bien dem i = 0
	li $s0, 0			# $s0 Dem so chu ky ngat
	li $t8, 0			# Bien dieu kien dem so chu ky
					# $t8 = 0: Chua dem, $t8 = 1: Bat dau dem
in_string_mau:
WaitForDis: 
	lw $t2, DISPLAY_READY		# Vong lap cho display san sang
 	beq $t2, $zero, WaitForDis 	# 
 	nop
 	lb $t1, string($t0)		# Doc string[i]
 	beq $t1, '\0', doc_ban_phim 	# if string[i] == NULL then break
	sw $t1, DISPLAY_CODE		# Hien thi string[i]
	add $t0, $t0, 1 		# i++
	j in_string_mau			# Lap lai vong lap

doc_ban_phim:
	li $t0, 0			# Bien dem i = 0
	#li $s0, 0			# $s0 Dem so chu ky ngat
	#li $t8, 0			# Bien dieu kien dem so chu ky
					# $t8 = 0: Chua dem, $t8 = 1: Bat dau dem
WaitForKey:
	lw $k1, KEY_READY	# Vong lap cho ban phim san sang
 	beqz $k1, WaitForKey	#
 	nop
 	li $t8, 1		# Dat $t8 = 1, Bat dau dem cac chu ky ngat
 	lw $k0, KEY_CODE	# Doc ky tu tu ban phim
 	beq $k0, 8, backspace	# Kiem tra nut xoa
 	beq $k0, 10, exit	# Ket thuc go neu nguoi dung nhan enter
 	
	sb $k0, buffer($t0)	# Luu lai phim vua go

 	add $t0, $t0, 1		# i++
 	j WaitForKey
backspace:
 	beqz $t0, WaitForKey	# if i == 0 {lap lai vong lap}
 	sb $zero, buffer($t0) 	# else{ buffer[i] = NULL;
 	add $t0, $t0, -1	#	i--;}
 	sb $zero, buffer($t0)	# Ky tu vua xoa cung gan bang null
 	j WaitForKey		# Lap lai vong lap
	
exit:
	li $v0, 4	#
	la $a0, buffer	#
	syscall		# In xau thu duoc tu ban phim
	
	li $v0, 4	#
	la $a0, speed	#
	syscall		# In xau speed
	
	mtc1 $t0, $f1		# Convert $t0(integer) -> $f1(float): so luong phim da nhap
	mtc1 $s0, $f2		# Convert $s0(integer) -> $f2(float): so luong time (so chu ky)
	div.s $f12, $f2, $f1	# Toc do trung binh (so chu ky ngat/1 ky tu)
	li $v0, 2
	syscall
	
	li $v0, 4		#
	la $a0, don_vi		#
	syscall			# In message don_vi
	
	li $s4, 0		# dung: $s4 dem so ky tu go dung
	li $t0, 0		# i: $t0 bien dem
string_cmp:
	lb $t1, string($t0) 	# $t1 = string[i]
	lb $t2, buffer($t0)	# $t2 = buffer[i]
	beqz $t1, mess		# if(string[i] == NULL) break;
	
	bne $t1, $t2, next_char	# If (String[i] == buffer[i])
	add $s4, $s4, 1		#	dung++;
next_char:
	add $t0, $t0, 1		# i++;
	j string_cmp		# Lap lai vong lap

mess:	
	li $v0, 4		#
	la $a0, count_true	#
	syscall			# In message count_true
	
	move $a0, $s4		#
	li $v0, 1		# In so ky tu go dung ra man hinh console
	syscall			#
	
	li $t4, 10 
	div $s4, $t4    	# Chia so ki tu go dung cho 10
	
	mflo $t0		# Lay so thuong ( Hang chuc)
	jal SET_DATA_FOR_7SEG	#
	move $a1, $a0		# Dat du lieu hang chuc cho led
	
	mfhi $t0		# Lay so du ( Hang don vi)
	jal SET_DATA_FOR_7SEG	# Dat du lieu hang don vi cho led
	
	jal SHOW_7SEG_RIGHT	# Hien thi hang don vi led phai
	jal SHOW_7SEG_LEFT	# Hien thi hang chuc led trai

	li $v0, 10		#
	syscall			# Goi thu tuc ket thuc chuong trinh
#---------------------------------------------------------------
# Function SHOW_7SEG_RIGHT : turn on/off the 7seg
# @param [in] $a0 value to shown
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_RIGHT: 
 	sb $a0, SEVENSEG_RIGHT # assign new value
 	jr $ra
#---------------------------------------------------------------
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# @param [in] $a1 value to shown
# remark $t0 changed
#--------------------------------------------------------------- 	
SHOW_7SEG_LEFT:
 	sb $a1, SEVENSEG_LEFT # assign new value
 	jr $ra
#---------------------------------------------------------------
# Function SET_DATA_FOR_7SEG : Chuyen du lieu he 10 sang kieu ma hoa LED
# @param [in] $t0 gia tri he 10
# @return $a0 Ma hoa tung vung hien thi den led
#--------------------------------------------------------------- 	
SET_DATA_FOR_7SEG:
	beq $t0, 0, __0
	beq $t0, 1, __1
	beq $t0, 2, __2
	beq $t0, 3, __3
	beq $t0, 4, __4
	beq $t0, 5, __5
	beq $t0, 6, __6
	beq $t0, 7, __7
	beq $t0, 8, __8
	beq $t0, 9, __9
	nop
__0:	li $a0, 0x3f
	j END__F
__1:	li $a0, 0x06
	j END__F
__2:	li $a0, 0x5B
	j END__F
__3:	li $a0, 0x4f
	li $s2, 3
	j END__F
__4:	li $a0, 0x66
	j END__F
__5:	li $a0, 0x6D
	j END__F
__6:	li $a0, 0x7d
	j END__F
__7:	li $a0, 0x07
	j END__F
__8:	li $a0, 0x7f
	j END__F
__9:	li $a0, 0x6f
	j END__F
END__F:
	jr $ra		
	

#+++++++++++++++++++++++++++++++++++++++++
#
# XU LY NGAT CHUONG TRINH 
#
#+++++++++++++++++++++++++++++++++++++++++		
.ktext 0x80000180 	
IntSR:
 move $t9, $at		# Luu lai gia tri thanh ghi $at
 mfc0 $v0, $13		# Kiem tra ma nguyen nhan ngat
 bne $v0, 1024, exit	# Ma ngat 1024, bo qua ma ngat do Counter cua Digit Lab Sim
 			# Ma ngat khac, la Loi => Ket thuc chuong trinh
 add $s0, $s0, $t8	# Tang bien dem so chu ky ngat
 			# Bien dem $s0 chi tang khi $t8 == 1 (Khi bat dau go)
 sge $v0, $s0, LIMIT_TIME	# Thoat neu dat so chu ky ngat toi da
 bnez $v0, exit			#
 nop
 move $at, $t9		# Khoi phuc thanh ghi $at
return: eret 		# Quay lai vi tri ngat
