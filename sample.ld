ENTRY(_start)

/* Specify the memory areas */
MEMORY
{
	CODE (rx)   : ORIGIN = 0x0, LENGTH = 4K
	DATA (rw)	: ORIGIN = 0x1000, LENGTH = 2K
}
/* Define output sections */

SECTIONS
{
	/* The program code and other data goes into FLASH */
	.text :
	{
		. = ALIGN(4);
		*(.text)        /* .text sections (code) */
		. = ALIGN(4);
		_etext = .;     /*define a global symbols at end of code */
	} > CODE
	
	.data :
    {
		_sdata = .;     /*define a global symbols at end of code */
        *(.data)
		_edata = .;     /*define a global symbols at end of code */
    } > DATA
	
    .bss :
    {
		_sbss = .;
        *(.bss)
		_ebss = .;
    } > DATA
	
	_estack = ORIGIN(DATA) + LENGTH(DATA);
}