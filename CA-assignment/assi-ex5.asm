.data
msg0: .asciiz"Exercise 5\n"
msg1: .asciiz"enter row of matrix A: "
msg2: .asciiz"enter cloumn of matrix A: "
msg3: .asciiz"enter row of matrix B: "
msg4: .asciiz"enter column of matrix B: "
msg5: .asciiz"wrong dimension!!! error code: "
msg6: .asciiz"enter element of matrixA \n"
msg7: .asciiz"enter element of matrixB \n"
msg8: .asciiz"  "
msg9: .asciiz"\n"
msg10: .asciiz"matrixR is: \n"
msg11: .asciiz"enter the upper bound:  "
msg12: .asciiz"matrixA is: \n"
msg13: .asciiz"matrixB is: \n"
foutA: .asciiz "A1.txt" # filename for output
foutB: .asciiz "B1.txt" # filename for output
foutR: .asciiz "R1.txt" # filename for output
fout: .asciiz "testout.txt" # filename for output
temp: .space 2000
.text
li $v0,4
la $a0,msg0
syscall
#row of A
li $v0,4
la $a0,msg1
syscall
li $v0,5
syscall
add $s3,$0,$v0
#column of A
li $v0,4
la $a0,msg2
syscall
li $v0,5
syscall
add $s4,$0,$v0
#row of B
li $v0,4
la $a0,msg3
syscall
li $v0,5
syscall
add $s5,$0,$v0
#column of B
li $v0,4
la $a0,msg4
syscall
li $v0,5
syscall
add $s6,$0,$v0

bne $s4,$s5,exit1
# s3= rowA
# s4= colA
# s5= rowB
# s6= colB
#s7= max integer 
li $v0,4
la $a0, msg11
syscall
li $v0,5
syscall
add $s7,$0,$v0 

enter_element_of_A:
li $t0,0         # set i = 0
mul $t6,$s3,$s4  # t6=rowA*colA 
sll $t6,$t6,2    # t6=t6*4 (total bytes)
# call dynamic array
li $v0, 9 	# system call code for dynamic allocation
add $a0,$0,$t6  # a0= 4*a0 ($a0 contains total number of bytes to allocate)
syscall
add $s0,$0,$v0  # transper v0-->s1
#################################
	loop_A:
 	   	li $v0, 42
 	   	add $a1,$0,$s7      
 	   	syscall   
 	   	
 	   	add $t9,$t0,$s0	      # t9= offset + address     
    		sw $a0,($t9)          # store input number into array     
		addi $t0,$t0,4	       # increment  4 bytes
		beq $t0,$t6,enter_element_of_B #if (number of bytes = total bytes ) break; 
	j loop_A

enter_element_of_B:
li $t0,0        # set i = 0
mul $t6,$s5,$s6 # t6=rowB*colB 
sll $t6,$t6,2   # t6=t6*4 (total bytes)
# call dynamic array
li $v0, 9 # system call code for dynamic allocation
add $a0,$0,$t6  # a0= 4*a0 ($a0 contains total number of bytes to allocate)
syscall
add $s1,$0,$v0 # transper v0-->s1
#################################
	loop_B:
 	   	li $v0, 42
 	   	add $a1,$0,$s7  # set max range    
 	   	syscall		# genearte random number
 	   	
 	   	add $t9,$t0,$s1 # t9= offset + address     
    		sw $a0,($t9)          # store input number into array
		addi $t0,$t0,4	       # increment  4 bytes
		beq $t0,$t6,enter_element_of_R #if (number of bytes = total bytes ) break; 
	j loop_B
	
enter_element_of_R:
# rowR = rowA
# colR = colB
li $t0,0        # set i = 0
mul $t6,$s3,$s6 # t6=rowB*colB 
sll $t6,$t6,2   # t6=t6*4 (total bytes)
# call dynamic array
li $v0, 9 # system call code for dynamic allocation
add $a0,$0,$t6  # a0= 4*a0 ($a0 contains total number of bytes to allocate)
syscall
add $s2,$0,$v0 # transper v0-->s1
#################################
	loop_R:
    		add $t9,$t0,$s2 		# t9= offset + address
    		sw $0,($t9)    			# store input number into array
		addi $t0,$t0,4	       		# increment  4 bytes
		beq $t0,$t6,end_enter_element   #if (number of bytes = total bytes ) break; 
	j loop_R
end_enter_element:

multiplication:
li $t0,0 # set i = 0
	loopi:
		beq $t0,$s3,end_loopi
		li $t1,0 # set j = 0
		loopj:
		beq $t1,$s6,end_loopj
		li $t2,0 # set k = 0
		li $t9,0 # temp result
				#load matrixR element
 	   			mul $t5, $s6, $t0       # $t5 = colB * i
    				add $t5, $t5, $t1       # $t5 = colB * i + j
 	   			sll $t5, $t5, 2         # $t5 = 2^2 * (colB * i + j)
 	   			add $t5,$t5,$s2
 	   			add $t8,$0,$t5
 	   			#lw $s2,matrixR($t5)
			loopk:
				beq $t2,$s4,end_loopk 
				#load matrixA element
				mul $t5, $s4, $t0       # $t5 = colA * i
    				add $t5, $t5, $t2       # $t5 = colA * i + k
 	   			sll $t5, $t5, 2         # $t5 = 2^2 * (colA * i + k)
 	   			add $t5,$t5,$s0		# t5 = offset + address 
				lw $t6,($t5)		# load value
				
				#load matrixB element
				mul $t5, $s6, $t2       # $t5 = colB * k
    				add $t5, $t5, $t1       # $t5 = colB * k + j
 	   			sll $t5, $t5, 2         # $t5 = 2^2 * (colB * k + j)
 	   			add $t5,$t5,$s1
 	   			lw $t7,($t5)
 	 
 	   			#calculate 
 	   			mul $t5,$t6,$t7 # $t5 = matrixA[i][k] * matrixB[k][j]
 	   			add $t9,$t9,$t5 # matrixR += $t5  
 	   			
 	   			addi $t2,$t2,1 #increase k by 1
 	   			
			j loopk
			end_loopk:
			sw $t9,($t8)
			addi $t1,$t1,1 #increase j by 1
		j loopj
		end_loopj:
		addi $t0,$t0,1 #increase i by 1		
	j loopi
	end_loopi:
	
save_loop:
addi $sp,$sp-4
mul $s7,$s3,$s4
la $a0,foutA
add $t2,$0,$s0
#sw $ra,0($sp)
jal enter_save_loop

addi $sp,$sp-4
mul $s7,$s5,$s6
la $a0,foutB
add $t2,$0,$s1
#sw $ra,0($sp)
jal enter_save_loop

addi $sp,$sp-4
mul $s7,$s3,$s6
la $a0,foutR
add $t2,$0,$s2
#sw $ra,0($sp)
jal enter_save_loop
j exit2

j save_loop
enter_save_loop:
sw $ra,0($sp)
addi $t0,$0,0 #initia1l count =0
addi $t1,$0,7
addi $t7,$0,45 # 45 is ASCII code of minus
addi $t5,$0,32# ASCII of space
#la $s0,temp
	loopA:
	beq $t0,$s7,endA #check for last element
	sll $s4,$t0,2 # offset of array[i]
	add $s4,$s4,$t2#offset + base address matrix[i]
	lw $t8,($s4) #load array[i]
	
	add $t6,$0,$t1 # set t6 = t1

	slt $t3,$t8,$0 #check t8 for negative 
	beq $t3,$0,positive # if (not negative) branch to "postitive"
pre_neg:
	sub $t8,$0,$t8 
negative:
	rem $t4,$t8,10 #take remainder of array[i]
	addi $t4,$t4,48	
	sb $t4,temp($t6)
	addi $t6,$t6,-1 #decrease 1 byte 
	div $t8, $t8, 10 # div array[i]
	beq $t8,$0,end_negative #check for null
	
j negative
end_negative:
	sb $t7,temp($t6) # store '-' to string
	addi $t6,$t6,-1 #decrease 1 byte 
	jal add_space
	add $t9,$0,$t1 
	addi $t9,$t9,1
	sb $t5,temp($t9) # store ' '  in case the number equal 8 byte and stand close 
	addi $t0,$t0,1
	addi $t1,$t1,8
j loopA

positive:
	rem $t4,$t8,10 #take raminder of array[i]
	addi $t4,$t4,48
	sb $t4,temp($t6)
	addi $t6,$t6,-1 #decrease 1 byte 
	div $t8, $t8, 10 # div array[i]
	beq $t8,$0,end_positive #check for null
j positive
end_positive:
	jal add_space
	add $t9,$0,$t1
	addi $t9,$t9,1
	sb $t5,temp($t9) # store ' '  in case the number equal 8 byte and stand close 
	addi $t0,$t0,1
	addi $t1,$t1,8
j loopA
add_space:
	addi $t9,$t1,-8
	loopB:
		beq $t6,$t9,end_addspace 
		sb $t5,temp($t6) #store sapce
		addi $t6,$t6,-1	
		
		
	j loopB
end_addspace:
jr $ra
endA:
# Open (for writing) a file that does not exist
li $v0, 13 # system call for open file
#la $a0, foutA # output file name
li $a1, 1 # Open for writing (flags are 0: read, 1: write)
li $a2, 0 # mode is ignored
syscall # open a file (file descriptor returned in $v0)
move $s7, $v0 # save the file descriptor
###############################################################
# Write temp to file just opened
li $v0, 15 # system call for write to file
move $a0, $s7 # file descriptor
la $a1, temp # address of buffer from which to write
li $a2, 300 # hardcoded buffer length
syscall # write to file
###############################################################
# Close the file
li $v0, 16 # system call for close file
move $a0, $s7 # file descriptor to close
syscall # close file
lw $ra,0($sp)
addi $sp,$sp,4
jr $ra
exit2:
li $v0,10
syscall

exit1:
	
	
	li $v0,4
	la $a0,msg5 # print error message
	syscall
	
	li $t9,-1
	li $v0,1
	add $a0,$0,$t9
	syscall
	
	li $v0,10
	syscall
                 
