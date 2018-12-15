.data 
emptyInput: .asciiz "Input is empty." 
inputTooLong: .asciiz "Input is too long." 
userInput: .space 1000
invalidNum: .asciiz "Invalid base-27 number."
storage: .space 4

.text 
main: 
	li $v0, 8 #reads string
	la $a0, userInput #stores string address  
	li $a1, 2000 #space for string
	syscall 
	
	add $t0, $0, 0 #sets registers to zero
	add $t1, $0, 0
	
	la $t2, userInput 
	lb $t0, 0($t2)
	beq $t0,10, printEmpty
	beq $t0, 0 printEmpty
	
	li $t0, 0 #updated for non 0 numbers 
	li $t3, 0
	li $t4, 0
	addi $s0, $0, 27 # my base number 
	
	
	spaces:
	lb $t0, 0($t2) #load address in $t2 to $t0
        addi $t2, $t2, 1 
        addi $t1, $t1, 1 
        beq $t0, 32, begin 
        beq $t0, 10, printEmpty #jump to exit branch if equal
        beq $t0, $0, printEmpty 
        
        
        
	loop: 
	lb $t1, 0($a0)
	beq $t1,10, exit
	
	addi $a0, $a0, 1
	beq $t1,' ', loop 
	
	addi $t0, $t0, 1
	
	blt $t1, 48, printInvalidNum
	bgt $t1, 118, exit
	beqz $t0, printEmpty  
	
	j loop
	
	exit:
	
	#this print out the count of the string 
	li $v0, 11
	ble $t0, 4, printEmpty
	move $a0, $t0
	beqz $t0, printInvalidNum
	move $a0, $t0
	bgt $t0, 4, printTooLong
	move $a0, $t0
	syscall 
	j end 
	
	begin: 
	sub $t0, $t0, $t3
	la $t3, 0
	#after reading  thru string 	
   	 printEmpty:
    	la $a0, emptyInput                  
    	li $v0, 4                                   
    	syscall
    	j end
    	
    	converting: 
    	blt $s3, 48, printInvalidNum
    	blt $s3, 58, anyNum
    	blt $s3, 65, printInvalidNum
    	blt $s3, 128, printInvalidNum
    	
    	 anyNum:
    	 addi $s3, $s3, -48
    	 j end 

    	printInvalidNum:
    	la $a0, invalidNum                    
    	li $v0, 4                                   
    	syscall
    	j end

    	printTooLong:
    	la $a0, inputTooLong                  
    	li $v0, 4                                   # load code to print string
    	syscall 
    	j end 
    	 
    	li $t0, 64  #if user input is withing range 64 and 91 
    	slt $t1, $t0, $t2
    	slti $t4, $2, 91
    	and $s5, $t1, $t4 
    	addi $s3, $t2, -55 
    	li $t7, 1 
    	beq $t7, $s5, convert
    	
    	convert:
    	mult $s0, $s1 
    	subu $t4, $t4, 1
    	beq $t4, 0, exit_loop
    	
    	li $t6, 27 
    	mult $s0, $t6
    	mflo $s0
    	
    	exit_loop:
    	subu $t3, $t3, 1
    	
    	end:
    	li $v0, 10                                  # load code to exit the program
    	syscall