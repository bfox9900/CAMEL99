\ Ternus illusion
\ ----------------
\ The Ternus illusion, also commonly referred to as the Ternus Effect is an 
\ illusion related to human visual perception involving apparent motion.

\ In a simplified explanation of one form of the illusion, two discs, 
\ are shown side by side as the first frame in a sequence of three frames. 

\ Next a blank frame is presented for a very short, variable duration. 
\ In the final frame, two similar discs are then shown in a shifted position. 
\ Depending on various factors including the time intervals between frames 
\ as well as spacing and layout, observers perceive either element motion, 
\ in which L appears to move to R while C remains stationary or they report 
\ experiencing group motion, in which L and C appear to move together to C and R. 
\ Both element motion and group motion can be observed in this demonstration


\  Character Patterns
HEX
CREATE SPOTDATA
       071F , 3F7F , 7FFF , FFFF , \ upper left
       E0F8 , FCFE , FEFF , FFFF , \ upper right
       FFFF , FF7F , 7F3F , 1F07 , \ lower left
       FFFF , FFFE , FEFC , F8E0 , \ lower right

DECIMAL
: AS_SPOT ( char -- ) SPOTDATA  SWAP ]PDT  32 VWRITE ;

: DRAW_SPOT ( 1stchar col row -- )
              AT-XY                   \ Position cursor
              DUP EMIT  1+ DUP EMIT   \ draw top 2 chars
              1 VROW +!  -2 VCOL +!   \ goto next row, back 2 cols.
              1+ DUP EMIT 1+ EMIT ;   \ draw bottom 2 chars

: FRAME1    16 1 1 COLOR   17 18 2 1 COLORS  ;
: FRAME2    16 18 1 1 COLORS  ;      \ blank frame
: FRAME3    16 17 2 1 COLORS   18 1 1 COLOR  ;

: TERNUS
     GRAPHICS  
     PAGE
     16 SCREEN
     8 0 AT-XY ." Ternus Illusion"

     128 AS_SPOT   16 2 1 COLOR
     136 AS_SPOT   17 2 1 COLOR
     144 AS_SPOT   18 1 1 COLOR

     128  5 10 DRAW_SPOT
     136 15 10 DRAW_SPOT
     144 25 10 DRAW_SPOT

    BEGIN
        BEEP
        0  23 BL 32 HCHAR
        1 23 AT-XY ." Element Motion (press key)"
        BEGIN
           FRAME1 500 MS
           FRAME2  15 MS
           FRAME3 500 MS
           FRAME2  15 MS
           KEY?
        UNTIL
        
        BEEP
        0  23 BL 32 HCHAR
        10 23 AT-XY ." GROUP Motion"
        BEGIN
           FRAME1 500 MS
           FRAME2 250 MS
           FRAME3 500 MS
           FRAME2 250 MS
           KEY?
        UNTIL
        ?BREAK
     AGAIN ;

