; Colour selector - live updates
; (C)2020 Chris Tyler - Seneca College
; Licensed under the GPLv2+ - see LICENSE file

; ROM routine entry points
define		SCINIT		$ff81 ; initialize/clear screen
define		CHRIN		$ffcf ; input character from keyboard
define		CHROUT		$ffd2 ; output character to screen
define		SCREEN		$ffed ; get screen size
define		PLOT		$fff0 ; get/set cursor coordinates

; zeropage variables
define		PRINT_PTR	$00
define		PRINT_PTR_H	$01
define		CURRENT		$02
define		SCRN_PTR	$03
define		SCRN_PTR_H	$04

; constants

; --------------------------------------------------------

		jsr SCINIT

		jsr PRINT
dcb "B","l","a","c","k",$0d
dcb "W","h","i","t","e",$0d
dcb "R","e","d",$0d
dcb "C","y","a","n",$0d
dcb "P","u","r","p","l","e",$0d
dcb "G","r","e","e","n",$0d
dcb "B","l","u","e",$0d
dcb "Y","e","l","l","o","w",$0d
dcb "O","r","a","n","g","e",$0d
dcb "B","r","o","w","n",$0d
dcb "L","i","g","h","t",32,"r","e","d",$0d
dcb "D","a","r","k",32,"g","r","e","y",$0d
dcb "G","r","e","y",$0d
dcb "L","i","g","h","t",32,"g","r","e","e","n",$0d
dcb "L","i","g","h","t",32,"b","l","u","e",$0d
dcb "L","i","g","h","t",32,"g","r","e","y",$0d
dcb $0d
dcb "S","e","l","e","c","t",32,"a",32,"c","o","l","o","u","r",32
dcb "a","b","o","v","e",32,"t","o",32,"s","e","e",32,"i","t",32
dcb "o","n",32,"t","h","e",32,"b","i","t","m","a","p","p","e","d",32
dcb "d","i","s","p","l","a","y",".",$0d
dcb 00


		lda #$00

get_colour:	jsr SELECT

		ldy #$00
		sty SCRN_PTR
		ldx #$02
		stx SCRN_PTR_H
		ldx #$04	; number of pages to fill

draw:		sta (SCRN_PTR),y
		iny
		bne draw

		inc SCRN_PTR_H
		dex
		bne draw

		jmp get_colour


; -----------------------------------------------------------
; SELECT :: select one line from the screen

SELECT:		sta CURRENT

show_and_go:	jsr HIGHLIGHT

getkey:		jsr CHRIN
		cmp #$80	; cursor up
		bne try_down

		lda CURRENT
		beq getkey
		jsr HIGHLIGHT
		dec CURRENT
		jmp return

try_down:	cmp #$82	; cursor down
		bne getkey

		lda CURRENT
		cmp #$0f
		beq getkey
		jsr HIGHLIGHT	
		inc CURRENT

return:		lda CURRENT

		rts


; --------------------------------------------------------
;
; Highlight :: highlight the CURRENT line on the display

HIGHLIGHT:	ldy CURRENT
		ldx #$00
		clc
		jsr PLOT


highlight_next:	sec
		jsr PLOT
		eor #$80
		jsr CHROUT

		inx
		cpx #20
		bne highlight_next

		rts


; --------------------------------------------------------
; Print a message
; 
; Prints the message in memory immediately after the 
; JSR PRINT. The message must be null-terminated and
; 255 characters maximum in length.

PRINT:		pla
		clc
		adc #$01
		sta PRINT_PTR
		pla
		sta PRINT_PTR_H

		tya
		pha

		ldy #$00
print_next:	lda (PRINT_PTR),y
		beq print_done
		
		jsr CHROUT
		iny
		jmp print_next

print_done:	tya
		clc
		adc PRINT_PTR
		sta PRINT_PTR

		lda PRINT_PTR_H
		adc #$00
		sta PRINT_PTR_H

		pla
		tay

		lda PRINT_PTR_H
		pha
		lda PRINT_PTR
		pha

		rts