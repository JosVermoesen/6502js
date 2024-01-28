define SCREEN $F000	; location of screen memory	

	LDY #$00		; index value (character we're currently processing)

CHAR:
	LDA TEXT,Y		; get a character from address (text + Y)
	BEQ DONE		; if character is NULL, branch to done
	STA SCREEN,Y	; store character at (SCREEN + Y)
	INY				; increment Y (go to next character)
	BNE CHAR		; repeat loop

DONE:
	BRK				; when we're done, break (stop the program)

TEXT:				; text to display
	dcb "H","e","l","l","o",32,"W","o","r","l"
	dcb "d","!",00
