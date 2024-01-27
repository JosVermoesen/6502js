; let the user type on the first page of character screen
; has blinking cursor!
; does not use ROM routines
; backspace works (non-destructive), arrows/ENTER don't
 
next:     ldx #$00
idle:     inx
          cpx #$10
          bne check
          lda $f000,y
          eor #$80
          sta $f000,y

check:    lda $ff
          beq idle

          ldx #$00
          stx $ff

          cmp #$08 ; bs
          bne print

          lda $f000,y
          and #$7f
          sta $f000,y

          dey
          jmp next

print:    sta $f000,y
          iny
          jmp next