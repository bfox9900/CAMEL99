( Graphics test program  )
DECIMAL

\ INCLUDE RANDOM.FTH

: RND(X)   ( -- x )  23 RND 1+ ;
: RND(Y)   ( -- y )  31 RND 1+ ;
: RND(C)   ( -- c)   15 RND 1+ ;

HEX
CREATE BARS FFFF , 0000 , FFFF , 0000 ,

DECIMAL
BARS 131 CHARDEF

: VSTUFF
    GRAPHICS
    BEGIN
       PAGE  0 0 AT-XY .S
       RND(C) SCREEN
       16 RND(C) RND(C) COLOR
       RND(Y) 0
      ?DO
         RND(Y) RND(X) 131 RND(X) VCHAR
       LOOP
       1000 MS
       KEY?
     UNTIL
     8 SCREEN  ;


\ non-aborting version of HCHAR
: HCHAR  ( col row char cnt -- ) \ parameter order not ideal so we shuffle
          SWAP >R >R         \ swap char & cnt, push to return stack
          >VPOS              \ -- vadr )
          R>  2DUP +
          C/SCR @ 1+ <
          IF   R> VFILL
          ELSE R> DROP
          THEN ;

: HSTUFF
    GRAPHICS
    BEGIN
       PAGE
       RND(C) SCREEN
       16 RND(C) RND(C) COLOR
       RND(Y) 0
      ?DO
         RND(Y) RND(X) 131 RND(X) HCHAR
       LOOP
       1000 MS
       KEY?
     UNTIL
     8 SCREEN  ;


: VHSTUFF
    GRAPHICS
    BEGIN
       PAGE
       RND(C) SCREEN
       16 RND(C) RND(C) COLOR
       RND(Y) 0
      ?DO
         RND(Y) RND(X) 131 RND(X) HCHAR
         RND(Y) RND(X) 131 RND(X) VCHAR
       LOOP
       1000 MS
       KEY?
     UNTIL
     8 SCREEN ;


