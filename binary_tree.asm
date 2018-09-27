# BTree struct
	.eqv	val		0
	.eqv	left		4
	.eqv	right		8
	.eqv	sizeof_node	12
	
	.eqv 	sDFS		0
	.eqv 	sINSERT		1
	.eqv	sSIZE		2
	.eqv	sSEARCH		3
	.eqv	sEXIT		4


.data
	root:		.word 8  n0 n1
	n0:		.word 3  n2 n3
 	n1:		.word 10 0  n4
	n2:		.word 1  0  0 
	n3:		.word 6  n5 n6
	n4:		.word 14 n7 0
	n5:		.word 4  0  0
	n6:		.word 7  0  0
	n7:		.word 13 0  0
	space:		.asciiz " "
	text: 		.asciiz "\nSize is "
	size_tree: 	.word 0
	num_searched:	.asciiz "The value of the node searched is: "
	found_node:	.word 0
	new_line:	.asciiz "\n"
	prompt_func:	.asciiz "Enter number of the function to be performed: \n"
	
	
	
.text
.globl main
main:
	



	
	#la $a0, root
	#jal size
	#sw $v0, size_tree
	
	#la $a0, text
	#li $v0, 4
	#syscall
	
	#lw $a0, size_tree
	#li $v0, 1
	#syscall
	
	#la $a0, root
	#li $a1, -2
	#jal insertion
	
	#la $a0, root
	#li $a1, 1
	#jal search
	#sw $v0, found_node
	
	#li $v0, 4
	#la $a0, num_searched
	#syscall
	
	#li $v0, 1
	#lw $a0, found_node
	#lw $a0, val($a0)
	#syscall
	
	#li $v0, 4
	#la $a0, new_line
	#syscall
	
	

	#la $a0, root
	#jal dfs
	
			
	li $v0, 10
	syscall


# $a1 receives node value
# $v0 returns node address
new_node:
	add $v0, $zero, $gp		# v0 = node location
	addi $gp, $gp, sizeof_node	# allocate memory of node in $gp
	sw $a1, val($v0)		# stores value
	sw $zero, left($v0)
	sw $zero, right($v0)
	jr $ra
	
# $a0 receives root, $a1 receives node value  
# $v0 returns new node
insertion:

	base_case:
		bne $a0, $zero, equals
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal new_node
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	equals:
		lw $t0, val($a0)
		bne $a1, $t0, insertion_rec
		add $v0, $zero, $a0
		jr $ra	

	insertion_rec:
		addi $sp, $sp, -8	
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		
		lw $t0, val($a0)
		slt $t1, $t0, $a1
		bne $t1, $zero, val_bigger
		
		val_smaller:
			lw $a0, left($a0)
			jal insertion
			lw $a0, 4($sp)
			sw $v0, left($a0)
			j end
		
		val_bigger:
			lw $a0, right($a0)
			jal insertion
			lw $a0, 4($sp)
			sw $v0, right($a0)
		
		end:
			lw $v0, 4($sp)
			lw $ra, 0($sp)
			addi $sp, $sp, 8
			jr $ra


# $a0 receives root, $a1 receives value to be searched
# $v0 returns node which value corresponds to value entered
search:
	bne $a0, $zero, equalsRec
	add $v0, $zero, $a0
	jr $ra
	
	equalsRec:
		lw $t0, val($a0)
		bne $a1, $t0, searchRec
		add $v0, $zero, $a0
		jr $ra
		
	searchRec:
		addi $sp, $sp, -8	
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		
		lw $t0, val($a0)
		slt $t1, $t0, $a1
		bne $t1, $zero, valBiggerSearch
		
		valSmallerSearch:
			lw $a0, left($a0)
			jal search
			j endSearch
		
		valBiggerSearch:
			lw $a0, right($a0)
			jal search
			
		endSearch:
			lw $a0, 4($sp)
			lw $ra, 0($sp)
			addi $sp, $sp, 8
			jr $ra

	
# $a0 receives root
dfs:
	bne $a0, $zero, dfs_recursive	# do not if node is null
	jr $ra
	
	dfs_recursive:
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		
		lw $a0, left($a0)
		jal dfs
		
		lw $t0, 4($sp)
		li $v0, 1
		lw $a0, val($t0)
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		lw $a0, right($t0)
		jal dfs
		
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		jr $ra
		
# $a0 receives root, $v0 returns size
size:
	bne $a0, $zero, size_recursive	# do not if node is null
	li $v0, 0
	jr $ra
	
	size_recursive:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		
		lw $a0, left($a0)
		jal size
		sw $v0, 8($sp)

		lw $t0, 4($sp)
		lw $a0, right($t0)
		jal size
		
		lw $t0, 8($sp)
		add $v0, $v0, $t0
		addi $v0, $v0 1
		
		lw $ra, 0($sp)
		addi $sp, $sp, 12
		jr $ra
		
		
		
		
	
