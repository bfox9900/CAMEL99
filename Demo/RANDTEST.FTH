\ TI-FORTH psuedo random number generator evaluation

\ ***EXPERIMENT***
\ RNDW replicates the function in TI-FORTH
\ The HISTOGRAM lets you see how it performs

: RNDW     ( -- n)   83C0 DUP @ 6FE5 * 7AB9 + 5 SRC DUP ROT ! ;
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

7C7C 7C7C 7C7C 7C00  PATTERN: SQUARE
SQUARE 30 CHARDEF

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

 
