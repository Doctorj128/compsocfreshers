BasicUpstart2(start)
	* = $080d

.var music = LoadSid("sids/compsocmusic.sid")

// 		Initialisation		//

start:
	sei					// Disable interrupts for initialisation

	lda #music.startSong-1
	jsr music.init		// Init sidfile


	lda #$35			// Disable BASIC and Kernal ROM
	sta $01

	lda #$7f			// Disable CIA interrupts
	sta $dc0d
	sta $dd0d

	lda $dc0d			// Remove pending CIA interrupts
	lda $dd0d

	lda #<irq1			// Set up interrupt pointer
	sta $fffe
	lda #>irq1
	sta $ffff

	lda #$01			// Enable VIC raster interrupt
	sta $d01a

	lda #$e0			// Set VIC raster interrupt
	sta $d012
	lda #$1b			// Make sure highest bit is still 0
	sta $d011

	lda #$0b			// Change background and border colour
	sta $d020
	sta $d021

						// Set screen memory locations
	lda #$18			// As the VIC bank is $0000,
	sta $d018			// Screen RAM=$0400
						// Bitmap RAM=$2000

chars:					// Set registers before copying character data
	ldx #$0
	ldy #$0

charload:
	lda $3f40,x			// Load character data into Accumulator
charstore:
	sta $0400,x			// Save character data
colourload:
	lda $4328,x			// Load colour data into Accumulator
colourstore:
	sta $d800,x			// Save colour data

	inx
	bne charload		// After 256 characters have been written, increment
	inc charload + 2	// the addresses by $100
	inc charstore + 2
	inc colourload + 2
	inc colourstore + 2
	iny					// Keep track of how much data has been written
	cpy #$4				// and break the loop after 1000 bytes
	bne charload


// Main section of program	//

main:
	ldx #0
writecredit:
	lda credit,x		// Load text into Accumulator

	cpx #$4f			// Break loop after 2 lines

	beq mainloop-1		// Jump to the instruction just before
						// the main loop
	sta $770,x			// Store into screen RAM
	inx
	jmp writecredit
	
	cli
mainloop:
	jmp *				// Infinite loop while waiting for interrupts
	

irq1:					// Begin double interrupt. This ensures
						// that the position of the VIC drawing the
						// current line is known

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

						// 16 CYCLES USED

	asl $d019			// Clear interrupt condition on VIC

						// 20 CYCLES USED

	lda #<irq2			// Set up pointer to stable raster interrupt
	sta $fffe
	lda #>irq2
	sta $ffff
						// 34 CYCLES USED

	inc $d012			// Set raster interrupt to the next line

	tsx					// Store the stack pointer (for correct rti)

						// 42 CYCLES USED
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
						// 64 CYCLES USED - next irq guaranteed


irq2:					// First interrupt (stable) - switch to
						// text mode

	txs					// Return stack pointer for correct rti

	ldx #$06			// Loop until VIC has reached the border
waitloop:
    dex
	bne waitloop

	asl $d019			// Clear interrupt condition on VIC
	
	lda #$14			// Return normal character set
	sta $d018

	lda #$1b			// Set character mode
	sta $d011

	lda #$ef			// Set raster line
	sta $d012

	lda #<irq3			// Set up interrupt pointer
	sta $fffe
	lda #>irq3
	sta $ffff

	rti
	

irq3:					// Second interrupt - enable hardware scroll

	ldx #$1f			// Set X register for loop

irq3loop:				// Waste enough cycles to hit the end of
	dex					// the line before changing scroll value
	bne irq3loop

	asl $d019			// Clear interrupt condition on VIC

	lda #$ff			// Set raster line
	sta $d012

	lda #$d0			// Set hardware scroll register based
	ora scroll			// on value of "scroll"
	sta $d016

	lda #<irq4			// Set up interrupt pointer
	sta $fffe
	lda #>irq4
	sta $ffff

	rti


irq4:					// Third interrupt - switch to
						// bitmap mode

	asl $d019			// Clear interrupt condition on VIC

	lda #$d0			// Reset scroll for bitmap
	sta $d016
	
	lda #$18			// Set bitmap character set
	sta $d018

	lda #$3b			// Set bitmap mode
	sta $d011

	lda #$e0			// Set raster line
	sta $d012

	lda #<irq1			// Set up interrupt pointer
	sta $fffe
	lda #>irq1
	sta $ffff

	jsr music.play


inccharacter:			// This section scrolls the text at the
						// bottom of the screen
						
	dec scroll
	lda scroll			// Check if the scroll register has reached below 0
	cmp #$ff			// and skip the text scroll if not
	bne returnirq2
	
	lda #$7				// Reset scroll when it reaches below 0
	sta scroll

	ldx #$0				// Reset register for looping
	inc textload+1

	lda textload+1		// Increment the high byte of the text address if
	bne textload		// it overflows
	inc textload+2


textload:				// This section scrolls the text by a whole character
						// if the scroll register has reached below 0
	lda text,x
	cpx #$28
	beq returnirq2
	cmp #$0				// If a 0 byte is read, reset the text pointer
	beq resettext
	sta $7c0,x
	inx
	jmp textload

resettext:
	lda #<text
	sta textload+1
	lda #>text
	sta textload+2
	
returnirq2:
	rti

//			Data			//

scroll:
	.byte $7

credit:
	.text "      luu compsoc stall 2022 demo       "
	.text "       - written by javid mann -        "

text:
	.text "                                        "
	.text "hello and welcome! this is the luu comp"
	.text "soc 2022 freshers stall demo. this prog"
	.text "ram was written entirely in 6502 assemb"
	.text "ly. read the printout or ask javid for "
	.text "a technical explanation!"
	.text "                                        "
	.byte $0

* = $2000
image:
	.var picture = LoadBinary("compsocimage.bin")
	.fill picture.getSize(), picture.get(i)

* = $5000 "Music"
	.fill music.size, music.getData(i)
