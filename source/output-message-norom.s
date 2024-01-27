define SCREEN $f000     ; location of screen memory

           ldy #$00      ; index value (character we're currently processing)
 
 char:     lda text,y    ; get a character from address (text + Y)
           beq done      ; if the character is NULL, branch to done
           sta SCREEN,y  ; store character at (SCREEN + Y)
           iny           ; increment Y (go to next character)
           bne char      ; repeat loop
 
 done:     brk           ; when we're done, break (stop the program)
 
 text:                   ; this is the text message
 dcb "6","5","0","2",32,"w","a","s",32,"h","e","r","e",".",00