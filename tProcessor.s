	.data

	.text
main:	
	add  	$s0, $zero, $zero
	addi 	$s1, $zero, 10
	lw 	$s2, 0($s1)
	srl 	$s2, $s2, 3
	sw	$s2, 0($s1)
	sll 	$s3, $s2, 1
	sub 	$s4, $s3, $s2
	sw 	$s4, 0($s1)