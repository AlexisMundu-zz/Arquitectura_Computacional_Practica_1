#Members: 
#	Pablo Avalos
#	Alexis Muñoz
#Description: Design a recursive program in assembly language that can solve the Hanoi towers problem.
.data
.text
main:
	addi $s0, $zero, 3	#s0 initialize the number of towers
	ori $s1, $zero, 4097	#add the address 1001
	sll $s1, $s1, 16	#shift to get the first address of memory
	add $s2, $zero, $s1
	ori $s2, $s2, 64	#initialize address for third tower
	add $s3, $zero, $s1
	ori $s3, $s3, 32	#initialize address for second tower
	add $t0, $zero, $s0	#initialize temp counter i = n
	add $t1, $zero, $zero	#intialize temp to break cycle
	add $t2, $zero, $s1	#pointer to first tower
loop_fill_stack:
	beq $t0, $t1, end_loop_fill_stack
	sw $t0, 0($t2)
	addi $t2, $t2, 4
	addi $t0, $t0, -1
	j loop_fill_stack
end_loop_fill_stack:
	#We have to store the arguments first
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
	sw $ra, 16($sp)		#store return address
	addi $t0, $zero, 1
	
	bne $a0, $t0, Recursiveness_1	#if n = 1 continue
	lw $t0, 0($a1)			#get value from origin
	sw $t0, 0($a2)			#copy value of origin to destiny
	sw $zero, 0($a1)		#clear origin
	lw $ra, 16($sp)			#get the return address
	addi $sp, $sp, 20		#go to previous status
	jr $ra
	
Recursiveness_1:
	#Store the current environment
	addi $a0, $a0, -1	# n-1
	add $a1, $a1, 4		#origin += 4	
	addi $sp, $sp, -20	#move stack pointer to save a new program status
	sw $a0, 0($sp)		#store n - 1
	sw $a1, 4($sp)		#store origin
	#swap aux and destinaton
	sw $a3, 8($sp)		#store aux as destination
	sw $a2, 12($sp)		#store dest as auxiliary
	jal towerOfHanoi
	
Middle_statement:
	#PROGRAM REACHED N = 1
	#Move origin to destination
	lw $a0, 0($sp)		#n
	lw $a1, 4($sp)		#origin
	lw $a2, 8($sp)		#destination
	lw $a3, 12($sp)		#auxiliary
	lw $t0, 0($a1)		#get value in origin
	sw $t0, 0($a2)		#move origin to destination
	sw $zero, 0($a1)	#clear origin
	
Recursiveness_2:
	addi $a2, $a2, 4	#dest += 4
	add $a0, $a0, -1	#n - 1
	#Store current environment
	sw $a0, 0($sp)		#store n - 1
	#swap origin and aux
	sw $a3, 4($sp)		#store aux as origin
	sw $a2, 8($sp)		#store destination
	sw $a1, 12($sp)		#store origin as auxiliary
	#We don't store the current address because we need to over write the function environment where it was called
	jal towerOfHanoi


exit:	#End of program
