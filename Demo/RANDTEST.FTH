\ psuedo random number generator evaluation

\ ***EXPERIMENT***
\ TI-FORTH RND versus GFORTH method

\ ********************************************
\ *** UN-COMMENT the one you want to test  ***
\ ********************************************

\ The HISTOGRAM lets you see how they perform
COLD

HEX
83C0 CONSTANT SEED   \ RAM where TI has a number incrementing in main menu

\ TI-METHOD
\ : RNDW     ( -- n)   SEED DUP @ 6FE5 * 7AB9 + 5 SRC DUP ROT ! ;
\ : RND      ( n -- n) RNDW ABS SWAP MOD ;
\ : RANDOMIZE ( -- )   8802 C@ DROP 0 BEGIN 1+ 8802 C@ 80 AND UNTIL SEED ! ;
\ : NAME$    S" TI Forth method"   ;


\ GFORTH METHOD
 1045 CONSTANT GEN#   \ GForth uses $10450405, we take the 1st 16 bits
 : RNDW      ( -- n )   SEED @ GEN# UM* DROP 1+ DUP SEED ! ;
 : RANDOMIZE ( n -- )   SEED ! ;
 : RND       ( n -- n') RNDW ABS SWAP MOD ;
 : NAME$    S" GForth method"  ;

\ ===================================
\ Test code using TI-99 display
DECIMAL
\ helper words
300 CONSTANT N                     \ no. of randoms to gen.
 30 CONSTANT 'BLK'                 \ BASIC cursor char.
    VARIABLE CNTR

HEX 7C7C 7C7C 7C7C 7C00 PATTERN: SQUARE

DECIMAL
SQUARE 'BLK' CHARDEF

: ++      ( addr --  ) 1 SWAP +! ; \ incr. a variable

: ERASE   ( adr n -- ) 0 FILL ;    \ erase some memory

: PROMPT  ( -- ) 0 23 BL 32 HCHAR   0 22 AT-XY  ;

CREATE HIST 32 CELLS ALLOT

: ]HIST  ( n -- addr) CELLS HIST + ; \ HIST array

: FILLIT ( -- )                      \ fill the array
         HIST 32 CELLS ERASE
         N 0
         DO
           32 RND ]HIST ++         \ rnd is the index
         LOOP 
         N CNTR +! ;

: .HISTOGRAM ( -- )                  \ draw the chart
         32 0
         DO
           I  21 I ]HIST @ -  'BLK' I ]HIST @ VCHAR
         LOOP ;

: RUN  ( -- )
       99 SEED
       GRAPHICS
       8 SCREEN CLEAR
       BEGIN
          FILLIT
          PAGE
          NAME$ 0 SWAP VWRITE
         .HISTOGRAM
          PROMPT SPACE CNTR @ U. ." random no.s "
          KEY?
       UNTIL ;

