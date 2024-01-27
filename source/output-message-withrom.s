; ROM routines
define		SCINIT		$ff81 ; initialize/clear screen
define		CHRIN		$ffcf ; input character from keyboard
define		CHROUT		$ffd2 ; output character to screen
define		SCREEN		$ffed ; get screen size
define		PLOT		$fff0 ; get/set cursor coordinates

          jsr SCINIT  ; initialize and clear the screen
          ldy #$00

char:     lda text,y
          beq done
          jsr CHROUT  ; put the character in A on to the screen
          iny
          bne char

done:     brk

text:
dcb "6","5","0","2",32,"w","a","s",32,"h","e","r","e",".",00