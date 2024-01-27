; zero-page variable locations
define	ROW		$20	; current row
define	COL		$21	; current column
define	POINTER		$10	; ptr: start of row
define	POINTER_H	$11

; constants
define	DOT		$01	; dot colour
define	CURSOR		$04	; black colour


	 	ldy #$00	; put help text on screen
print:		lda help,y
		beq setup
		sta $f000,y
		iny
		bne print

setup:		lda #$0f	; set initial ROW,COL
		sta ROW
		sta COL

draw:		lda ROW		; ensure ROW is in range 0:31
		and #$1f
		sta ROW

		lda COL		; ensure COL is in range 0:31
		and #$1f
		sta COL

		ldy ROW		; load POINTER with start-of-row
		lda table_low,y
		sta POINTER
		lda table_high,y
		sta POINTER_H

		ldy COL		; store CURSOR at POINTER plus COL
		lda #CURSOR
		sta (POINTER),y

getkey:		lda $ff		; get a keystroke
		beq getkey

		ldx #$00	; clear out the key buffer
		stx $ff

		cmp #$43	; handle C or c
		beq clear
		cmp #$63
		beq clear

		cmp #$80	; if not a cursor key, ignore
		bmi getkey
		cmp #$84
		bpl getkey

		pha		; save A

		lda #DOT	; set current position to DOT
		sta (POINTER),y

		pla		; restore A

		cmp #$80	; check key == up
		bne check1

		dec ROW		; ... if yes, decrement ROW
		jmp done

check1:		cmp #$81	; check key == right
		bne check2

		inc COL		; ... if yes, increment COL
		jmp done

check2:		cmp #$82	; check if key == down
		bne check3

		inc ROW		; ... if yes, increment ROW
		jmp done

check3:		cmp #$83	; check if key == left
		bne done

		dec COL		; ... if yes, decrement COL
		clc
		bcc done

clear:		lda table_low	; clear the screen
		sta POINTER
		lda table_high
		sta POINTER_H

		ldy #$00
		tya

c_loop:		sta (POINTER),y
		iny
		bne c_loop

		inc POINTER_H
		ldx POINTER_H
		cpx #$06
		bne c_loop

done:		clc		; repeat
		bcc draw


; these two tables contain the high and low bytes
; of the addresses of the start of each row

table_high:
dcb $02,$02,$02,$02,$02,$02,$02,$02
dcb $03,$03,$03,$03,$03,$03,$03,$03
dcb $04,$04,$04,$04,$04,$04,$04,$04
dcb $05,$05,$05,$05,$05,$05,$05,$05,

table_low:
dcb $00,$20,$40,$60,$80,$a0,$c0,$e0
dcb $00,$20,$40,$60,$80,$a0,$c0,$e0
dcb $00,$20,$40,$60,$80,$a0,$c0,$e0
dcb $00,$20,$40,$60,$80,$a0,$c0,$e0

; help message for the character screen

help:
dcb "A","r","r","o","w",32,"k","e","y","s"
dcb 32,"d","r","a","w",32,"/",32,"'","C","'"
dcb 32,"k","e","y",32,"c","l","e","a","r","s"
dcb 00