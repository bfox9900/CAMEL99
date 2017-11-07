\ random number generator adapted from HS/Forth
\ Jim Kalihan 1990 (R.I.P.)

\ TI-FORTH PRNG

\ ***EXPERIMENT***
\ RNDW is a code word in the CAMEL99 KERNEL.
\ If you un-comment the definition below it will replace the ASM version
\ when you compile this program.
\ Run both ways and observe the speed increase!

\ : RNDW     ( -- n)   83C0 DUP @ 6FE5 * 7AB9 + 5 SRC DUP ROT ! ;

: RND      ( n -- n) RNDW ABS SWAP MOD ;
: SEED     ( n -- )  83C0 ! ;
: RANDOMIZE ( -- )   8802 C@ DROP 0 BEGIN 1+ 8802 C@ 80 AND UNTIL SEED ;

\ ===================================
\ Test code using TI-99 display
DECIMAL
\ helper words
300 CONSTANT N                     \ no. of randoms to gen.
 30 CONSTANT 'BLK'                 \ BASIC cursor char.
    VARIABLE CNTR

HEX" 7C7C 7C7C 7C7C 7C00"  30 CHARDEF

: CELLS   ( n -- cells) 2* ;       \ 16bits = 2 bytes
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
         LOOP ;

: .HISTOGRAM ( -- )                  \ draw the chart
         32 0
         DO
           I  21 I ]HIST @ -  'BLK' I ]HIST @ VCHAR
         LOOP ;

: RUN  ( -- )
       99 SEED
       GRAPHICS
       12 SCREEN CLEAR
       BEGIN
          PROMPT SPACE CNTR @ U. ." random no.s" CR
          FILLIT
          CLEAR \ ." CAMEL99 Histogram:" N . ." no.s"  CR
          .HISTOGRAM
          300 CNTR +!
          KEY?
       UNTIL  ;

 