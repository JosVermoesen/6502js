define WIDTH 	4 ; width of graphic
 define HEIGHT 	4 ; height of graphic
 
 
 	lda #$25	; create a pointer at $10
 	sta $10		;   which points to where
 	lda #$02	;   the graphic should be drawn
 	sta $11
 
 	lda #$00	; number of rows we've drawn
 	sta $12		;   is stored in $12
 
 	ldx #$00	; index for data
 	ldy #$00	; index for screen column
 
 draw:	lda data,x
 	sta ($10),y
 	inx
 	iny
 	cpy #WIDTH
 	bne draw
   
 	inc $12		; increment row counter
 
 	lda #HEIGHT	; are we done yet?
 	cmp $12
 	beq done	; ...exit if we are
 
 	lda $10		; load pointer
 	clc
 	adc #$20	; add 32 to drop one row
 	sta $10
 	lda $11         ; carry to high byte if needed
 	adc #$00
 	sta $11
 
 	ldy #$00
 	beq draw
 
 done:	brk		; stop when finished
 
 data:                 ; graphic to be displayed
 dcb 00,03,03,00
 dcb 07,00,00,07
 dcb 07,00,00,07
 dcb 00,03,03,00