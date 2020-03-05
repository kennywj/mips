
/*
 *  MIPS assembly start code
 *
 *  load data section, and clear bss section, then jump to main function
*/	
.global  _start
.extern	 main
	
.text
_start:
	la		$gp, _sdata
	la		$sp, _estack
	/*
	 * reload data section
	*/
	la 		$t1, _etext
	la 		$t2, _sdata
	la      $t3, _edata
loop1:
	lw 		$t4, 0($t1)
	sw 		$t4, 0($t2)
	addiu  	$t1, $t1, 4
	addiu   $t2, $t2, 4
	blt 	$t2, $t3, loop1

	/*
	* clear BSS area
	*/
	la		$t1, _sbss
	la      $t2, _ebss
loop2:
	sw		$t0, 0($t1)
	addiu	$t1, $t1, 4
	blt		$t1, $t2, loop2
	/*
	 * call main function
	 */
	jal 		main
done:
	j		done
/*
 *	end program
 */
	.word  _estack  /* address of end of system stack */
	.word  _etext	/* end address for the .text section. defined in linker script */
	.word  _sdata	/* start address for the .data section. defined in linker script */
	.word  _edata	/* end address for the .data section. defined in linker script */
	.word  _sbss	/* start address for the .bss section. defined in linker script */
	.word  _ebss	/* end address for the .bss section. defined in linker script */

