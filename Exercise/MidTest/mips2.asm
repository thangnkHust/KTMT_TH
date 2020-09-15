.data
	students: .space 5200 # Array to store blocks (52) of 100 student
	input_name: .asciiz "Nhap ten sinh vien"
	input_mark: .asciiz "Nhap diem sinh vien"
	input_count: .asciiz "Nhap so luong sinh vien"
	st_list: .asciiz "Danh sach sinh vien "
	mark_and_name: .asciiz "\nDiem\tHo va Ten\n"
	sorted_list: .asciiz "\nDanh sach da sap xep:\n"
	err_mss: .asciiz "Diem nhap vao khong hop le!"
	name_err_mss: .asciiz "Ten nhap vao khong hop le!"
	count_err_mss: .asciiz "So luong sinh vien khong hop le!"
	sv: .asciiz " sinh vien\n"
	min: .float 4.0
	khong: .float 0.0
	muoi: .float 10.0
	so_sinh_vien: .word
.text
__read_info_student:
	la $s1, students # Nap dia chi cua mang $s1
	move $t1, $s1 # Gán dia chi cua mang vao $t1

	l.s $f2, khong # Nap gia tri toi thieu la 0.0
	l.s $f3, muoi # Nap gia tri toi da la 10.0
count:
	li $v0, 51 # Goi hop thoai nhap so luong sinh viên
	la $a0, input_count # $a0 tiêu de: "Nhap so luong sinh vien"
	syscall #
	beq $a1, -2, exit # Thoat khi nhan cancel
	bnez $a1, __error_count #
	move $s0, $a0 # So vua nhap vao $a0, gán cho $s0
	sw $s0, so_sinh_vien
	li $v0, 4 #
	la $a0, st_list # In ra chuoi "Danh sach sinh vien "
	syscall # trên giao dien console
	li $v0, 1 # Goi hàm in so nguyên
	move $a0, $s0 # In ra so sinh viên vuaa nhap
	 #
	li $v0, 4 # Goi hàm in string
	la $a0, sv # in ra chuoi " sinh vien"
	syscall #
	la $a0, mark_and_name # in ra chuoi "Diem Ho va Ten"
	syscall

	li $t0, 0 # khoi tao $t0 = 0, $t0 là bien diem cua sinh viên vua duco nhap thong thông tin
loop:
	slt $v0, $t0, $s0 # So sánh $t0 (So sinh vien nhap thông tin) và $s0 (Tong so sinh viên)
	beqz $v0, end_loop # Thoát vong lap khi nhap du thông tin cho các sinh viên
name: 
	li $v0, 54 # Goi hop thoai nhap ten sinh viên
	la $a0, input_name # Tieu de "Nhap ten sinh vien"
	la $a1, 4($t1) # Chi ra vi trí luu tên
	li $a2, 46 # Gioi han do dài tên 46 ki tu
	syscall #
	bnez $a1, __error_name

mark: 
	li $v0, 52 # Goi hop thoai nhap ðiem (Kieu float)
	la $a0, input_mark # Tiêu de "Nhap diem sinh vien"
	syscall #
	bnez $a1, __mark_error # Yêu cau nhap lai neu ðiem sai
	c.le.s $f0, $f3 # Kiem tra ðiem <= 10
	li $v0, 1 #
	movt $v0, $zero # Gán $v0 = 0 neu ðiem <= 10
	bnez $v0, __mark_error # Nhap lai neu ðiem > 10
	c.le.s $f2, $f0 # Kiem tra 0.0 <= ðiem
	li $v0, 1
	movt $v0, $zero # Gán $v0 = 0 neu ðiem <= 10
	bnez $v0, __mark_error # Nhap lai neu ðiem < 0
	s.s $f0, ($t1) # Luu diem vào mang
	li $v0, 2 #
	mov.s $f12, $f0 # In ðiem ra màn hinh console
	syscall #
	li $v0, 11 #
	li $a0, '\t' # In dau tab
	syscall #
	li $v0, 4 #
	la $a0, 4($t1) # In tên sinh viên ra màn hinh console
	syscall #
	addi $t0, $t0, 1 # Tãng bien ð?m s? lý?ng sv ð? duocc nhap thông tin
	addi $t1, $t1, 52 # block tiep theo
	j loop # Lap lai vong lap
end_loop:
	j __bubble_sort
__mark_error:
li $v0, 55 # Thông báo diem nhap l0i
la $a0, err_mss #
li $a1, 0 #
syscall
j mark

__error_name:
li $v0, 55 # Thông báo ðiem nhap l0i
la $a0, name_err_mss #
li $a1, 0 #
syscall
j name
__error_count:
li $v0, 55 # Thông báo ðiem nhap loi
la $a0, count_err_mss #
li $a1, 0 #
syscall
j count
#################################
# Bat dau sap xep #
#################################
__bubble_sort:
la $s0, students #load dia chi mang a vào $s0
la $s3, students #load dia chi mang a vào $s3
addi $t2, $t0, 0 #i = n
loop1: # for i = n-1 to 0
addi $t2, $t2, -1 # i = i - 1
add $s0, $s3, $zero #luu diaa chi mang a
li $t3, 0 #gán j = 0
beq $t2, 0, break # so sánh i voi 0 neu bang nhau thì re nhánh xuong nhãn break
loop2: #for j = 0 to i - 1
beq $t2, $t3, loop1 # if j == i then loop1
l.s $f1, 0($s0) # Load a[j] luu vào $s1
addi $s0, $s0, 52 #tang dia chi lên 52
l.s $f2, 0($s0) # Load a[j+1]
#slt $a0, $s2, $s1 # if a[j+1] < a[j] then
c.lt.s $f2, $f1
li $a0, 1
movt $a0, $zero
bne $a0, $zero, incre
jal swap
incre: addi $t3, $t3, 1 # j = j + 1
j loop2 #nhay vao loop2

break:

j __show_student
swap:
li $s7, 0
addi $t4, $s0, -52
loopx:
slti $v0, $s7, 13
beqz $v0, end_loopx
lw $a1, 0($t4)
lw $a2, 52($t4)
sw $a1, 52($t4)
sw $a2, 0($t4)
addi $t4, $t4, 4
addi $s7, $s7, 1
j loopx
end_loopx:
jr $ra

__show_student:
lw $s0, so_sinh_vien
la $t1, students # Nap ðia chi ð?u m?ng các block lýu thông tin sinh viên
li $v0, 4 # Go i hàm in string
la $a0, sorted_list #
syscall #
la $a0, mark_and_name # in ra chuoi "Diem Ho va Ten"
syscall
li $t0, 0 # Khoi tao $t0 = 0, $t0 là bien ðiem so sinh viên da duoc duyet
loop3:
slt $v0, $t0, $s0 # So sánh $t0 (So sv da duyet) và $s0 (Tong so sinh viên)
beqz $v0, exit # Thoát vong lap khi duyet het sinh viên

li $v0, 2 #

l.s $f12, 0($t1) # In ðiem ra màn hinh console
syscall #
li $v0, 11 #
li $a0, '\t' # In dau tab
syscall #
li $v0, 4 #
la $a0, 4($t1) # In tên sinh viên ra màn hinh console
syscall #
continue:
addi $t0, $t0, 1 # Tãng bien ðem so luong sv da duyet
addi $t1, $t1, 52
j loop3 # Lap lai vong lap
exit:
li $v0, 10
syscall