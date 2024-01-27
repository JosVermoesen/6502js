; 6502 Assembly Language
; ROM routines
define		SCINIT		$ff81 ; initialize/clear screen
define		CHROUT		$ffd2 ; output character to screen

; Memory locations
define		INPUT		$2000 ; input buffer (up to 5 chars)

	JSR SCINIT

	LDY #$00

PROMPT_CHAR:
	LDA PROMPT_TEXT,Y
	BEQ DONE_PROMPT
	JSR CHROUT
	INY
	BNE PROMPT_CHAR

DONE_PROMPT:
	LDA #$0D
	JSR CHROUT
	LDY #$00

	BRK

PROMPT_TEXT:
	dcb "H","e","l","l","o",32,"W","o","r","l"
	dcb "d","!",00
