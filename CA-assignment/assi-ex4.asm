.data
matrixA: .space 800
matrixB: .space 800
matrixR: .space 800
msg1: .asciiz"enter row of matrix A: "
msg2: .asciiz"enter cloumn of matrix A: "
msg3: .asciiz"enter row of matrix B: "
msg4: .asciiz"enter column of matrix B: "
msg5: .asciiz"wrong dimension!!! "
msg6: .asciiz"enter element of matrixA \n"
msg7: .asciiz"enter element of matrixB \n"
msg8: .asciiz"  "
msg9: .asciiz"\n"
msg10: .asciiz"matrixR is: \n"
.text
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

bne $s4,$s5,exit
# s3= rowA
# s4= colA
# s5= rowB
# s6= colB
enter_element_of_A:
li $v0,4
la $a0,msg6
syscall
li $t0,0 # set i = 0
mul $t6,$s3,$s4
sll $t6,$t6,2
	loop_A:
 	   	li $v0, 5              
    		syscall
    		sw $v0, matrixA($t0)          # store input number into array
		addi $t0,$t0,4	       # increment  4 bytes
		beq $t0,$t6,enter_element_of_B #if (number of bytes = total bytes ) break; 
	j loop_A

enter_element_of_B:
li $v0,4
la $a0,msg7
syscall
li $t0,0        # set i = 0
mul $t6,$s5,$s6 # t6=rowB*colB 
sll $t6,$t6,2   # t6=t6*4 (total bytes)
	
	loop_B:
 	   	li $v0, 5              
    		syscall
    		sw $v0, matrixB($t0)          # store input number into array
		addi $t0,$t0,4	       # increment  4 bytes
		beq $t0,$t6,enter_element_of_R #if (number of bytes = total bytes ) break; 
	j loop_B
	
enter_element_of_R:
# rowR = rowA
# colR = colB
li $t0,0 # set i = 0
mul $t6,$s3,$s6 # t6=rowB *colR 
sll $t6,$t6,2 # t6=t6*4 (total bytes)
	loop_R:
    		sw $0, matrixR($t0)          # store input number into array
		addi $t0,$t0,4	       # increment  4 bytes
		beq $t0,$t6,end_enter_element #if (number of bytes = total bytes ) break; 
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
				#load matrixR element
				li $t9,0 # temp result
 	   			mul $t5, $s6, $t0       # $t5 = colB * i
    				add $t5, $t5, $t1       # $t5 = colB * i + j
 	   			sll $t5, $t5, 2         # $t5 = 2^2 * (colB * i + j)
 	   			add $s2,$0,$t5
 	   			#lw $s2,matrixR($t5)
			loopk:
				beq $t2,$s4,end_loopk 
				#load matrixA element
				mul $t5, $s4, $t0       # $t5 = colA * i
    				add $t5, $t5, $t2       # $t5 = colA * i + k
 	   			sll $t5, $t5, 2         # $t5 = 2^2 * (colA * i + k)
				lw $s0,matrixA($t5)
				
				#load matrixB element
				mul $t5, $s6, $t2       # $t5 = colB * k
    				add $t5, $t5, $t1       # $t5 = colB * k + j
 	   			sll $t5, $t5, 2         # $t5 = 2^2 * (colB * k + j)
 	   			lw $s1,matrixB($t5)
 	 
 	   			#calculate 
 	   			mul $t5,$s0,$s1 # $t5 = matrixA[i][k] * matrixB[k][j]
 	   			add $t9,$t9,$t5 # matrixR += $t5  
 	   			
 	   			addi $t2,$t2,1 #increase k by 1
 	   			
			j loopk
			end_loopk:
			sw $t9,matrixR($s2)
			addi $t1,$t1,1 #increase j by 1
		j loopj
		end_loopj:
		addi $t0,$t0,1 #increase i by 1		
	j loopi
	end_loopi:
	li $v0,4
	la $a0,msg10
	syscall
print_result:
	
	li $t0,0 # set i = 0
	loop_iR1:
		beq $t0,$s3,exit2 #if (i = rowA ) break; 
		li $t1,0 		      # set j = 0
		loop_jR1:
			beq $t1,$s6,end_loop_jR1  #if(j=colB)break;
			mul $t5, $s6, $t0       # $t5 = colB * i
    			add $t5, $t5, $t1       # $t5 = colB * i + j
 	   		sll $t5, $t5, 2         # $t5 = 2^2 * (colB * i + j)
 	   		
    			lw $t3,matrixR($t5)
    			#print result element
    			li $v0,1
    			add $a0,$0,$t3
    			syscall
    			
    			li $v0,4
    			la $a0,msg8
    			syscall
    			
			addi $t1, $t1, 1       # increment j by 1
		j loop_jR1
		end_loop_jR1:
			addi $t0,$t0,1 	       # increment i by 1
			li $v0,4
    			la $a0,msg9
    			syscall
	j loop_iR1
	
exit2:
	li $v0,10
	syscall
exit:
	li $v0,4
	la $a0,msg5 # print error message
	syscall
	li $v0,10
	syscall
                 
