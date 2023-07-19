.data
	ask_to_fill_node: .asciz "Please give positive numbers to fill the list and a non possitive to stop.\n"
	ask_num_serch: .asciz "plese give a non negative number to print all the biger numbers in the lister or a negative to terminate the program\n" 
	space: .asciz " "
	new_line: .asciz "\n"
	

.text
main:
#7.4	
	jal ra, node_alloc    #jumping to node_alloc function for the dummy node
	
	add s0, x0, a0	   #saving the pointer to the head of the list in register s0
	add s1, x0, a0     #saving the pointer to the tail of the list in register s1
	sw x0, 0(s0)       #initializing the data of dummy node with zero
	sw x0, 4(s0)       #initializing the PrNext of dummy node with zero
	
	addi a7, x0, 4             #print instractions on how to fill the node
	la a0, ask_to_fill_node
	ecall
	
	jal ra, read_loop
#7.5
	exit_of_read_loop:
	addi a7, x0, 4      #set ecall to print string
	la a0, ask_num_serch #print this sting
	ecall                #print that sting
	
	jal ra, read_int      #read int with function 
	
	blt a0, x0, end     #if negative exit with fun error
	
	add s1, x0, a0      #save the int given to compara in register s1
	add s2, x0, s0      #save the head of the list to register s2
	
	add a0, x0, s2      #save the head of the list as the fist argument 
	add a1, x0, s1      #save the number to compare as the second argument 
	jal ra, search_list #jump to serch_list to search and print the needed nodes
	
	addi a7, x0, 4    #set ecall to print_string
	la a0, new_line   #add the string to print
	ecall             #print the string
	
	j exit_of_read_loop #ask for another num to comparare and start again
	
	 
#nide_alloc function that creates a node and reterns a pointer to its first byte in register a0
node_alloc:
	addi a7, x0, 9    #mode sbrk for the ecall(malloc)   
	addi a0, x0, 8    #8 bytes for the sbrk 
	ecall	          #call sbrk with returns the pointer to a0
	jr ra	          #return
	
	
#read_int function reades a int from the user and returns it in register a0
read_int:
	addi a7, x0, 5 #mode scan int for ecall
	ecall          #scan int
	jr ra	       #return
	
	
#read_loop reads ints from the user until a not possitive int is given, adds a new node to the list 
#with the dada as the int giver conenting it to the list, updates the head of the list in reg s1
read_loop:
	jal ra, read_int  #jumping to read_int function
	
	bge x0, a0, exit_of_read_loop  #if input <= 0 brange to cont (exit loop)
	
	addi sp, sp, -4
	sw a0, 0(sp)      #save the data in the stack pointer before calling the function
	jal ra, node_alloc #jump to node_alloc function
	lw t0, 0(sp)       #retrive data from sp and save to reg temp0
	addi sp, sp, 4
	
	sw t0, 0(a0)	 #input value to the first word of the new node
	sw x0, 4(a0)	 #this is now the tail of the list so its PtrNext = 0
	sw a0, 4(s1)     #save the new node to the PtrNext of the node that was the tail
	add s1, x0, a0   #update the s1 to show the new tail
	
	j read_loop      #jump to the start of the read_loop 
	

#function that searches the nodes in a list and prints those that have data biger that a givern number
#(takes the head of list in a0, the number to compare at a1)	
search_list:
	new_search:
	#saving the ra and the arguments before calling the print_node funct
	addi sp, sp, -12    #extent stack pointer
	sw ra, 0(sp)        #save return addres
        sw a0, -4(sp)       #save fist arg
        sw a1, -8(sp)       #save second arg
        
        add a0, x0, a0      #preparing the first argummens for the function (here they are in the same register so we dont have to but its good practis)
        add a1, x0, a1      #preparing the second argummens for the function (here they are in the same register so we dont have to but its good practis)
        lw a0, 0(a0)        #restore the pointer to the start of the current node 
        jal ra, print_node  #call the print_node funct
        
        #restore the values we saved in the stack before calling the print_node func
        lw ra, 0(sp)    #restore return addrese
        lw a0, -4(sp)   #restore first arg
        lw a1, -8(sp)   #restore second arg
        addi sp, sp, 12  #restore stack pointer  
        
        
        lw s2, 4(s2)   #set head to the NextPointer of the current node
        add a0, x0, s2 #set the first arg to the start of the next node (new head)
        bne a0, x0, new_search  #if that next pointer is not equal to NULL search it and if needed print it
                                #else return
        jr ra
        
	
#function that prints the nodes in a list that have data biger that a givern number
#(takes the head of list in a0, the number to compare at a1) 
print_node:
	
   
	bge a1, a0, exit_print_node #checking if the number in the data segment of the node has to be printed
	                            #if so print else brach to exit_print_node
	addi a7, x0, 1   #set ecall to print int
    	add a0, x0, a0   #set int to print ( not neded it is allready in the correct reg)
    	ecall            #priint int
    	
    	addi a7, x0, 4   #set ecall to print sting
    	la a0, space     #addres of the string to print 
    	ecall            #print selected string
    	
    	exit_print_node:
    	jr ra
	
	
#end fuction is called to end the programm (takes no variables)	
end:
	addi a7, x0, 10   #set ecall to exit 
	ecall            #exit
