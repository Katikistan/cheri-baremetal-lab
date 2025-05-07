OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    /* 2 GiB of shared memory */
    rom (rxa) : ORIGIN = 0x80000000, LENGTH = 16M
    ram (wxa) : ORIGIN = 0x81000000, LENGTH = 2032M
}

SECTIONS
{
    .text : ALIGN(CONSTANT(MAXPAGESIZE))
    {
	*(.text.start);
	PROVIDE(_text_start = .);
	*(.text.init) *(.text .text.*)
	PROVIDE(_text_end = .);
    } > rom

    .rodata : ALIGN(CONSTANT(MAXPAGESIZE))
    {
	PROVIDE(_rodata_start = .);
	*(.rdata)
	*(.rodata .rodata.*)
	PROVIDE(_rodata_end = .);
    } > rom

    .data : ALIGN(CONSTANT(MAXPAGESIZE))
    {
	PROVIDE(_data_start = .);
	. = ALIGN(8);
	PROVIDE( __global_pointer = . + 0x800 );
	*(.sdata .sdata.*) *(.data .data.*)
	PROVIDE(_data_end = .);
    } > ram

    .bss : ALIGN(CONSTANT(MAXPAGESIZE))
    {
	PROVIDE(_bss_start = .);
	*(.sbss .sbss.*) *(.bss .bss.*)
	PROVIDE(_bss_end = .);
    } > ram

    . = ALIGN(16);
    _end = .;

    .stack : ALIGN(CONSTANT(MAXPAGESIZE))
    {
	. = ALIGN(8);
	. += 0xFF000;
	PROVIDE(_stack_start = .);
	. += 0x8000000; /* 1024 programs * 128 KiB = 128 MiB */
	PROVIDE(_stack_top = .);
    } > ram

    .heap : ALIGN(CONSTANT(MAXPAGESIZE)) /* ~1903 MiB */
    {
	. = ALIGN (4096);
	PROVIDE(_heap_start = .); 
	PROVIDE(_heap_top = ORIGIN(ram) + LENGTH(ram) - 0x1000);
    } > ram
}