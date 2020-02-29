/*
 *  MIPS assembly sample code
 *
 *  load N form memory,  i = N*N + 3*N, store i to memory N
*/
.global  _start

.data
	N:       .word  5
	
.text
_start:
	lw     $t0, N($gp)       # fetch N
    mul    $t0, $t0, $t0     # N*N
    lw     $t1, N($gp)       # fetch N
    ori    $t2, $zero, 3     # 3
    mul    $t1, $t1, $t2     # 3*N
    add    $t2, $t0, $t1     # N*N + 3*N
    sw     $t2, N($gp)       # i = ...
end:
	j 		end				 # done
