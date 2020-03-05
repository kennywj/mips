/*
 *  MIPS assembly instructions
 *	list all possible instructions which can be used in MIPS controller
*/
.global  _start

.data
	N:			.word  5
	array1:		.byte	'a','b'	# create a 2-element character array with elements initialized to  a  and  b
	array2:		.space	40		# allocate 40 consecutive bytes, with storage uninitialized
	
.text
_start:
	/* C code: 
	 * i = (N*N + 3*N - N) *2
	 */
	lw     $t0, 4($gp)       # fetch N
    mul    $t0, $t0, $t0     # N*N
    lw     $t1, 4($gp)       # fetch N
    ori    $t2, $zero, 3     # 3
    mul    $t1, $t1, $t2     # 3*N
    addu   $t2, $t0, $t1     # N*N + 3*N
    subu   $t2, $t2, $t1     # i - N
    sra    $t2, $t2, 1       # i*2
    sw     $t2, 0($gp)       # i = ...
    
	/* C code:
    * A[i] = A[i/2] + 1;
    * A[i+1] = -1;
    */
	/* A[i] = A[i/2] + 1; */	
    lw     $t0, 0($gp)       # fetch i
    srl    $t0, $t0, 1       # i/2
    addi   $t1, $gp, 28      # &A[0]
    sll    $t0, $t0, 2       # turn i/2 into a byte offset (*4)
    add    $t1, $t1, $t0     # &A[i/2]
    lw     $t1, 0($t1)       # fetch A[i/2]
    addi   $t1, $t1, 1       # A[i/2] + 1
    lw     $t0, 0($gp)       # fetch i
    sll    $t0, $t0, 2       # turn i into a byte offset 
    addi   $t2, $gp, 28      # &A[0]
    add    $t2, $t2, $t0     # &A[i]
    sw     $t1, 0($t2)       # A[i] = ...
    
	/*  A[i+1] = -1; */
    lw     $t0, 0($gp)       # fetch i
    addi   $t0, $t0, 1       # i+1
    sll    $t0, $t0, 2       # turn i+1 into a byte offset
    addi   $t1, $gp, 28      # &A[0]
    add    $t1, $t1, $t0     # &A[i+1]
    addi   $t2, $zero, -1    # -1
    sw     $t2, 0($t1)       # A[i+1] = -1
    
    /*	C code:
 	*   if (i<N) {
    * 		A[i] = 0;
	*	}
    */
    lw     $t0, 0($gp)        # fetch i
    lw     $t1, 4($gp)        # fetch N
    slt    $t1, $t0, $t1      # set $t1 to 1 if $t0 < $t1, to 0 otherwise
    beq    $t1, $zero, skip   # branch if result of slt is 0 (i.e., !(i<N))
    sll    $t0, $t0, 2        # i as a byte offset
    add    $t0, $t0, $gp      # &A[i] - 28
    sw     $zero, 28($t0)     # A[i] = 0
skip:

	/* C code :
	 * background.blue = background.blue * 2;   // Note: overflow...
	 */
	lw    $t0, 1060($gp)      # fetch background
    andi  $t1, $t0, 0xff00    # isolate blue
    sll   $t1, $t1, 2         # times 2
    andi  $t1, $t1, 0xff00    # get rid of overflow
    lui   $t2, 0xffff         # $t2 = 0xffff0000
    ori   $t2, $t2, 0x00ff    # $t2 = 0xffff00ff
    and   $t0, $t0, $t2       # get rid of old value of blue
    or    $t0, $t0, $t1       # new value
    sw    $t0, 1060($gp)      # background = ...
    
    /* C code:
    * 
    * if ( N%2 == 0 ) N++;		// set N to the smallest odd no less than N
    */
    lh    $t0, 4($gp)         # fetch N
    ori   $t0, $t0, 1         # turn on low order bit
    sh    $t0, 4($gp)         # store result in N
    
    lb    $t0, 1($gp)         # fetch N
    ori   $t0, $t0, 1         # turn on low order bit
    sb    $t0, 1($gp)         # store result in N
    
    /* C code:
    *  switch (i) {
    *    case 0:   A[0] = 0;
	*          break;
    *    case 1:
    *    case 2:   A[1] = 1;
    *              break;
    *    default:  A[0] = -1;
    *              break;
    *}
    */
    lw    $t0, 0($gp)          # fetch i
    bltz  $t0, def             # i<0 -> default
    slti  $t1, $t0, 3          # i<3?
    beq   $t1, $zero, def      # no, -> default
    sll   $t0, $t0, 2          # turn i into a byte offset
    add   $t2, $t0, $gp
    lw    $t2, 1064($t2)       # fetch the branch table entry
    jr    $t2                  # go...
is0: 
	sw    $zero, 28($gp)       # A[0] = 0
    j     done
is1: 
is2: 
	addi  $t0, $zero, 1        # = 1
    sw    $t0, 32($gp)         # A[1] = 1
    j     done
def: 
	addi  $t0, $zero, -1       # = -1
    sw    $t0, 28($gp)         # A[0] = -1
    j     done
done:

    /* C code:
    * for (i=0; i<N; i++) {
    *     A[i] = MAX_SIZE;
    * }
    */
    add    $t0, $gp, $zero      # &A[0] - 28
    lw     $t1, 4($gp)          # fetch N
    sll    $t1, $t1, 2          # N as byte offset
    add    $t1, $t1, $gp        # &A[N] - 28
    ori    $t2, $zero, 256      # MAX_SIZE
top:
    sltu   $t3, $t0, $t1        # have we reached the final address?
    beq    $t3, $zero, done1    # yes, we're done
    sw     $t2, 28($t0)         # A[i] = 0
    addi   $t0, $t0, 4          # update $t0 to point to next element
    j      top                  # go to top of loop
done1:

	/* C code:
    * while(i) {
    *     i--;
    * }
    */
    lw     $t1, 4($gp)          # fetch N
    lw     $t2, 8($gp)          # fetch M
loop:
	sub    $t1, $t1, 1			# N = N-1
	bne    $t1, $t2, loop
	 
end:
	j 		end				    # forever loop - done


