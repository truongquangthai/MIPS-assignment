.data
array: .space 300
msg1: .asciiz "enter number of elemnts in array: "
msg2: .asciiz "enter size of element(bytes): "
msg4: .asciiz"  "
msg5: .asciiz"\naddress of first element: "
msg6: .asciiz"return code is:  "
.text
#ask for number of element

li $t3,65536 

li $v0,4
la $a0,msg1
syscall
li $v0,5
syscall
add $s0,$0,$v0 # set s0=v0 (number of elements)

li $t1,0 # set count = 0
li $s1,0 #total bytes of array
enter_size_loop:
	beq $t1,$s0,end_size_loop
	#ask for size of element
	li $v0,4
	la $a0,msg2
	syscall
	
	li $v0,5
	syscall 
	add $s1,$s1,$v0   # set s1=v0(size of each element)
	addi $sp,$sp,-4 
	sw $v0,($sp)      # save size of each element in stack to use use later
	addi $t1,$t1,1
j enter_size_loop

end_size_loop:
li $t9,0 #return code
slt $t0,$s1,$t3  # if s7 > 65536
beq $t0,$0,error # brach to error
#call dynamic array
li $v0,9
add $a0,$0,$s1	#size of array
syscall
add $s3,$0,$v0 #move array from v0 to s3

j exit

error:
	li $t9,-1      # return code = -1
	
	li $v0,4
	la $a0,msg6
	syscall 
	
	#print return code
	li $v0,1
	add $a0,$0,$t9 
	syscall
	
	li $v0,10
	syscall

exit:	
	li $v0,4
	la $a0,msg6
	syscall 
	
	#print return code
	li $v0,1
	add $a0,$0,$t9 
	syscall
	
	
	li $v0,4
	la $a0,msg5
	syscall 
	# print address of first element
	addi $t0,$0,0
	add $t0,$t0,$s3
	li $v0,1
	add $a0,$0,$s3
	syscall
,
	li $v0,10
	syscall
	

