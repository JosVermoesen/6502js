; Adding calculator

; ROM routine entry points
define		SCINIT		$ff81 ; initialize/clear screen
define		CHRIN		$ffcf ; input character from keyboard
define		CHROUT		$ffd2 ; output character to screen
define		SCREEN		$ffed ; get screen size
define		PLOT		$fff0 ; get/set cursor coordinates

; zeropage variables
define		PRINT_PTR	$10
define		PRINT_PTR_H	$11
define		value		$14
define		value_h		$15

; absolute variables
define		GETNUM_1	$0080
define		GETNUM_2	$0081

; constants

; --------------------------------------------------------

		jsr SCINIT
		jsr CHRIN

		jsr PRINT

dcb "A","d","d","i","n","g",32
dcb "c","a","l","c","u","l","a","t","o","r",00

start:		jsr PRINT
		
dcb $0d,$0d,"E","n","t","e","r",32,"a",32,"n","u","m","b","e","r"
dcb "(","0","-","9","9",")",":"
dcb 32,32,32,32,32,32,32,32,00

		lda #$00
		sta value_h

		jsr GETNUM
		sta value

		jsr PRINT

dcb "E","n","t","e","r",32,"a","n","o","t","h","e","r"
dcb 32,"n","u","m","b","e","r",32,"(","0","-","9","9",")",":",32,00

		jsr GETNUM
	
		sed
		clc
		adc value
		cld

		sta value
		bcc result
		inc value_h

result:		pha
		jsr PRINT

dcb "R","e","s","u","l","t",":",32
dcb 32,32,32,32,32,32,32
dcb 32,32,32,32,32,32,32
dcb 32,32,32,32,32,32,32
dcb 00

		lda value_h
		beq low_digits
		lda #$31
		jsr CHROUT
		jmp draw_100s

low_digits:	lda value
		and #$f0
		beq ones_digit

draw_100s:	lda value
		lsr
		lsr
		lsr
		lsr
		ora #$30
		jsr CHROUT

ones_digit:	lda value
		and #$0f
		ora #$30
		jsr CHROUT

		jsr start

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

; ---------------------------------------------------
; GETNUM - get a 2-digit decimal number
;
; Returns A containing 2-digit BCD value

GETNUM:		txa
		pha
		tya
		pha

		ldx #$00	; count of digits received
		stx GETNUM_1
		stx GETNUM_2


getnum_cursor:	lda #$a0	; black square
		jsr CHROUT
		lda #$83	; left cursor
		jsr CHROUT

getnum_key:	jsr CHRIN
		cmp #$00
		beq getnum_key

		cmp #$08	; BACKSPACE
		beq getnum_bs

		cmp #$0d	; ENTER
		beq getnum_enter

		cmp #$30	; "0"
		bmi getnum_key

		cmp #$3a	; "9" + 1
		bmi getnum_digit

		jmp getnum_key

getnum_enter:	cpx #$00
		beq getnum_key

		lda #$20
		jsr CHROUT
		lda #$0d
		jsr CHROUT

		lda GETNUM_1

		cpx #$01
		beq getnum_done

		asl
		asl
		asl
		asl
		ora GETNUM_2

getnum_done:	sta GETNUM_1
		pla
		tay
		pla
		tax
		lda GETNUM_1

		rts

getnum_digit:	cpx #$02
		bpl getnum_key
		pha
		jsr CHROUT
		pla
		and #$0f
		sta GETNUM_1,x
		inx
		jmp getnum_cursor

getnum_bs:	cpx #$00
		beq getnum_key
		lda #$20
		jsr CHROUT
		lda #$83
		jsr CHROUT
		jsr CHROUT
		lda #$20
		jsr CHROUT
		lda #$83
		jsr CHROUT
		dex
		lda #$00
		sta GETNUM_1,x
		jmp getnum_cursor