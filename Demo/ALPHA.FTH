\ alpha intelligence demonstration using sprites

VARIABLE RND#

HEX
: SCRAMBLE   ( -- n) 83D6 @ 8379 C@ * C3E9 XOR ; ( we had to build a random number generator)
: RANDOMIZE  ( -- ) SCRAMBLE RND# ! ;            ( named it like TI-BASIC )

: RND  ( n -- )                                  ( this one too )
        RND# @ SCRAMBLE XOR >< ABS
        DUP RND# ! SWAP MOD ;

: RNDX  ( -- n) 4 RND 2- ;

: REVERSE  ( n -- ) DUP >R ]MOTION 2@ NEGATE SWAP NEGATE SWAP  R> ]MOTION 2! ;


\ ==================================
\ screen stuff
HEX
: GRASS        ( -- n1 n2 n3 n4)  AA55 4489 2002 4801 ;

DECIMAL

  GRASS 159 CHARDEF   159 SET# 2 3 COLOR

: ALPHA-GUY  ( -- )  16 42 10 10 0 SPRITE   1 -1 0 MOTION ;

: .BORDER   ( -- )
          \ col row
             0   1 159 32 HCHAR
             0  23 159 32 HCHAR
             0   1 159 23 VCHAR
            31   1 159 23 VCHAR ;

: .WALLS
             10 10 159 10 VCHAR
             11 15 159 18 HCHAR
             5   5 159  8 HCHAR
             10  5 159 10 VCHAR
             13  5 159  4 VCHAR
             13 11 159  3 VCHAR
             13 13 159  8 HCHAR
             23  4 159 10 VCHAR ;

\ ==================================
\ motion control

: 8/        ( n -- n') 3 RSHIFT ;  \ convert pixels to char. row/col

\ need to compensate look ahead for forward or backward motion.
\ sprites are pixels, chars are text row,col
: CLIP       ROT MIN MAX ;
: COLAHEAD  ( n -- nextcol) 0 ]MOTION @ 8*    0 31 CLIP  ;
: ROWAHEAD  ( n -- nextrow) 0 ]MOTION 2+ @ 8* 0 23 CLIP  ;

: SPACE?     ( row col -- ?)
              8/ SWAP  8/ SWAP GCHAR BL = ;  \ is there at space @row.col

: CLEAR-AHEAD? ( -- ?)
                0 POSITION ROWAHEAD +  SWAP COLAHEAD + SWAP SPACE? ;

: MOVE-FORWARD ( -- ) 0 SP.MOVE  SP.UPDATE ;

: NON-0        ( -- n) BEGIN RNDX DUP 0 <> UNTIL ;

: NEW-VECTORS  ( -- X Y)      \ we need to prevent a (0,0) vector condition
               RNDX DUP 0=    \ If 1st # is 0
               IF
                 NON-0        \ wait for a non-zero 2nd #
               ELSE
                RNDX
               THEN ;

: REVERSE  ( n -- ) DUP >R ]MOTION 2@ NEGATE SWAP NEGATE SWAP  R> ]MOTION 2! ;

HEX
VARIABLE TRYS

: .R   ( u n -- )  >R DUP ABS 0 <# #S ROT SIGN #>  R> OVER - SPACES TYPE ;

: .BRAIN     ( COL ROW -- )
             0 0 AT-XY ." Vectors:"  0 ]MOTION 2@  4 .R  4 .R
             2 SPACES  ." Trys:" THOUGHTS @ 4 .R  ;


: ACOLOR    ( n -- ) 0 SP.COLOR SP.UPDATE ;

: ALPHA-THINK   ( -- )
                 BEEP
                 TRYS OFF                   \ reset the trys counter
                 9 ACOLOR                   \ change char color to RED while thinking
                 BEGIN
                    1 TRYS +!               \ count the try
                    NEW-VECTORS 0 MOTION    \ get new rnd vectors into sprite motion
                    CLEAR-AHEAD?
                 UNTIL
                 10 ACOLOR ;                \ restore to color 16
DECIMAL
: RUN      ( -- )
           PAGE ." Alpha Intelligence Demo"
           12 SCREEN
           .BORDER .WALLS
           ALPHA-GUY
           BEGIN
              CLEAR-AHEAD?
              IF   MOVE-FORWARD  \ if true
              ELSE ALPHA-THINK   \ otherwise
              THEN 2 MS          \ then delay a bit
              KEY?
           UNTIL ;

