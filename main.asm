#Members: 
#	Pablo Avalos
#	Alexis Muñoz
#Description: Design a recursive program in assembler language that can solve the Hanoi towers problem.
.data
.text
main:
	addi $s0, $zero, 3	#s0 initialize the number of towers
	ori $s1, $zero, 4097	#add the address 1001
	sll $s1, $s1, 16	#shift to get the first address of memory
	add $s2, $zero, $s1
	ori $s2, $s2, 32	#initialize address for third tower
	add $s3, $zero, $s1
	ori $s3, $s3, 64	#initialize address for third tower
	add $t0, $zero, $s0	#initialize temp counter i = n
	add $t1, $zero, $zero	#intialize temp to break cycle
loop_fill_stack:
	beq $t0, $t1, end_loop_fill_stack
	sw $t0, 0($s1)
	addi $s1, $s1, 4
	addi $t0, $t0, -1
	j loop_fill_stack
end_loop_fill_stack:
	#Store the function arguments 
	addi $sp, $sp, -20	#move stack pointer to save function arguments
	sw $s0, 0($sp)		#store n
	sw $s1, 4($sp)		#store origin
	sw $s2, 8($sp)		#store destination
	sw $s3, 12($sp)		#store auxiliary
	jal towerOfHanoi
	j exit
	


towerOfHanoi:
	#Firstly we load the function arguments 
	lw $a0, 0($sp)		#n
	lw $a1, 4($sp)		#origin
	lw $a2, 8($sp)		#destination
	lw $a3, 12($sp)		#auxiliary
	sw $ra, 16($sp)		#store the return address
	addi $t0, $zero, 1
	bne $a0, $t0, endTowerOfHanoi	#if n = 1
	addi $a1, $a1, -4
	lw $t0, 0($a1)
	sw $t0, 0($a3)			#origin to destiny
	sw $zero, 0($a1)		#clear origin
	addi $a3, $a3, 4
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra
endTowerOfHanoi:
	#Store the current environment
	addi $a0, $a0, -1	# n-1
	#Make a swap between destiny and auxiliary
	add $t0, $zero, $a3	#save temp destiny
	add $a3, $zero, $a2	#auxiliary = destiny
	add $a2, $zero, $t0	#destiny = auxiliary
	addi $sp, $sp, -20	#move stack pointer to save new environment
	sw $a0, 0($sp)		#store n
	sw $a1, 4($sp)		#store origin
	sw $a2, 8($sp)		#store destination
	sw $a3, 12($sp)		#store auxiliary
	jal towerOfHanoi


	
exit: