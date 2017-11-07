\ BOUNCE exercises the Sprites under direct program control

\ NEEDS SPRITES.FTH

HEX

83C0 CONSTANT SEED   \ RAM where TI has a number incrementing in main menu
1045 CONSTANT GEN#   \ GForth uses $10450405, we take the 1st 16 bits

: RNDW      ( -- n )   SEED @ GEN# UM* DROP 1+ DUP SEED ! ;
: RANDOMIZE ( n -- )   SEED ! ;
: RND       ( n -- n') RNDW ABS SWAP MOD ;

: RNDX  ( -- n) 4 RND 2- ;

DECIMAL
: ].MOTION ( n -- ) ]MOTION @ SPLIT . . ;

: .MOTION
           CR
           32 0 DO
             I ].MOTION  5 SPACES I 1+  ].MOTION CR
           2 +LOOP ;

 DECIMAL
\ clr chr   Y  X  #          y  x  #
\ ------------------------------------------
  16   42   1  1  0 SPRITE  -3  2  0 MOTION
  2    65  10 10  1 SPRITE   2 -3  1 MOTION

HEX
: REVERSE  ( n -- ) 
           DUP >R ]MOTION 2@  NEGATE SWAP NEGATE SWAP  R> ]MOTION 2! ;

: BOINK    ( -- )
           BEGIN
              PAUSE
              0 1 6 COINC
              IF  0 REVERSE  1 REVERSE  HONK  THEN
              ^C?
           UNTIL ;

DECIMAL
: INSIDE?    ( row col -- ?)
             3 250 WITHIN            \ 0 0 AT-XY 2DUP 3 U.R  3 U.R
             3 185 WITHIN OR  ;


: NEW-DIRECTION   ( sprt# -- )
                 DUP POSITION        \ save current position
                 ROT SP.STOP         \ stop moving
                                     ( -- col row)
                 BEGIN
                    PAUSE
                    2DUP RNDX RNDX  VECT+
                    INSIDE?
                 UNTIL
                 ROT MOTION BEEP ;

: BOUNCE    ( -- )
            PAGE
            SP.SHOW
            1 MAGNIFY                                                 Q
            BEGIN
               MOVEALL  100 MS
               0 POSITION
               INSIDE? 0=
               IF  0 NEW-DIRECTION THEN

               COINCALL IF  0 REVERSE  1 REVERSE  HONK  THEN
               PAUSE
               KEY?
            UNTIL ;

