.data

temp:.space 300
array: .space 300
array2: .space 300
fout: .asciiz "testout.txt" # filename for output
msg1: .asciiz "enter number of elemnts of array: "
msg2: .asciiz "string load from file \n"
msg3: .asciiz " \n"
msg4: .asciiz "\nloaded array is: \n"
string:  .space 300
.text
###############################################################

# Open (for writing) a file that does not exist
li $v0, 13 # system call for open file
la $a0, fout # output file name
li $a1, 1 # Open for writing (flags are 0: read, 1: write)
li $a2, 0 # mode is ignored
syscall # open a file (file descriptor returned in $v0)
move $s6, $v0 # save the file descriptor
###############################################################
#ask for number of elements
li $v0,4
la $a0,msg1
syscall

li $v0,5
syscall
add $t2,$0,$v0 # max size of array
#enter element of array
addi $t0,$0,0 #initial count =0
arrayloop:
	li $v0,5
	syscall
	add $t1,$0,$v0
	sll $t7,$t0,2
	sw $t1,array($t7)
	addi $t0,$t0,1
	beq $t0,$t2,end_array_loop
j arrayloop
end_array_loop:
add $s5,$0,$t0 # s5 = size of array = t0
addi $t0,$0,0 #initia1l count =0
addi $t1,$0,7
addi $t7,$0,45 # 45 is ASCII code of minus
addi $t8,$0,0
addi $t5,$0,32# ASCII of space
#la $s0,temp
loopA:
	beq $t0,$s5,endA #check for last element
	sll $s4,$t0,2 # offset of array[i]
	lw $s1,array($s4) #load array[i]
	
	add $t6,$0,$t1 # set t6 = t1

	slt $t3,$s1,$0 #check for negative 
	beq $t3,$0,positive # if (not negative) branch to "postitive"
pre_neg:
	sub $s1,$t8,$s1 
negative:
	rem $t4,$s1,10 #take raminder of array[i]
	addi $t4,$t4,48	
	sb $t4,temp($t6)
	addi $t6,$t6,-1 #decrease 1 byte 
	div $s1, $s1, 10 # div array[i]
	beq $s1,$0,end_negative #check for null
	
j negative
end_negative:
	sb $t7,temp($t6) # store '-' to string
	addi $t6,$t6,-1 #decrease 1 byte 
	jal add_space
	addi $t0,$t0,1
	addi $t1,$t1,8
j loopA

positive:
	rem $t4,$s1,10 #take raminder of array[i]
	addi $t4,$t4,48
	sb $t4,temp($t6)
	addi $t6,$t6,-1 #decrease 1 byte 
	div $s1, $s1, 10 # div array[i]
	beq $s1,$0,end_positive #check for null
j positive
end_positive:
	jal add_space
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

###############################################################
# Write temp to file just opened
li $v0, 15 # system call for write to file
move $a0, $s6 # file descriptor
la $a1, temp # address of buffer from which to write
li $a2, 300 # hardcoded buffer length
syscall # write to file
###############################################################
# Close the file
li $v0, 16 # system call for close file
move $a0, $s6 # file descriptor to close
syscall # close file
###############################################################
 # Open (for reading) a file
li $v0, 13 # system call for open file
la $a0, fout # output file name
li $a1, 0 # Open for writing (flags are 0: read, 1: write)
li $a2, 0 # mode is ignored
syscall # open a file (file descriptor returned in $v0)
move $s6, $v0 # save the file descriptor
###############################################################
###############################################################
# Read from file
li $v0, 14 # system call for read
move $a0, $s6 # file descriptor
la $a1, string # address of buffer read
li $a2, 300 # hardcoded buffer length
syscall # read from file
###############################################################
li $v0,4
la $a0,string
syscall
###############################################################
# Close the file
li $v0, 16 # system call for close file
move $a0, $s6 # file descriptor to close
syscall # close file

pre_loop:
#la $s1,string
li $t7,45 # ASCII of minus
li $t8,32 # ASCII of space
li $t0,0  # bytes
li $t3,7  # set size(bytes) = 0
li $s0,0  # sum
li $t5,10 # base
li $s6,0 #count = 0
lp:
	beq $t3,$t1,end_lp
	addi $t2,$t3,-8   # set t2 = t3
	li $t6,1
	j read_loop
read_loop:		
	addi $t2,$t2,1
	lbu $t4,string($t2)
	beq $t4, $t8,space_check    # check for space
	beq $t4, $t7,negative_check # check for '-'
	addi $t4,$t4,-48	    # ASCII to integer
	mul $s0,$s0,$t5		    # sum= sum*10
	add $s0,$s0,$t4		    # sum += string[i] 
	beq $t2,$t3,combine
j read_loop
###################
space_check:
	
j read_loop
###################
negative_check:
	li $t6,0
j read_loop
###################
combine:
	beq $t6,$0,minus
array_saved:
	sw $s0,array2($s6)
	addi $s6,$s6,4
	li $s0,0
	addi $t3,$t3,8
j lp
###################
minus:
	sub $s0,$0,$s0
	li $t6,1
j array_saved

end_lp:
li $t6,0	

li $v0,4
la $a0,msg4
syscall
print_loop:
	beq $t6,$s6,end_print_loop
	lw $s3,array2($t6)
	
	li $v0,1
	add $a0,$0,$s3
	syscall
	
	li $v0,4
	la $a0,msg3
	syscall
	
	addi $t6,$t6,4
	
j print_loop

end_print_loop:
li $v0,10
syscall
