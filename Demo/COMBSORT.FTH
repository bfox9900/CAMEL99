\ combsort.fth  taken from byte April 1991.  coded bfox Sept 94
\ PORTED to CAMEL99 Forth 2017

\ Approximately 10X faster than BUBBLE Sort except when list is 
\ already sorted.

HEX
83C0 CONSTANT SEED   \ RAM where TI has a number incrementing in main menu
1045 CONSTANT GEN#   \ GForth uses $10450405, we take the 1st 16 bits
: RNDW      ( -- n )   SEED @ GEN# UM* DROP 1+ DUP SEED ! ;
: RANDOMIZE ( n -- )   SEED ! ;
: RND       ( n -- n') RNDW ABS SWAP MOD ;

VARIABLE GAP
VARIABLE ITEMS
VARIABLE ADR
VARIABLE SFLAG
VARIABLE PASSES

DECIMAL
255 CONSTANT SIZE

CREATE Q   SIZE CELLS CELL+ ALLOT

: ]Q  ( n -- adr) CELLS Q + ;   \ this is faster than using DOES>

\ : RND() ( -- N) 200 RND ;

: ERASE   0 FILL ;
: CLEARIT   0 ]Q SIZE CELLS ERASE ;  \ all the same data
: SEEIT   SIZE  0 DO  I ]Q @ U.  LOOP ;


\ LOAD THE ARRAY WITH DIFFERENT KINDS OF MIXED UP DATA
: FILLIT    SIZE  0 DO   I  I ]Q !      LOOP ;

: RANDIT    SIZE  0 DO  256 RND I ]Q !   LOOP ;

: TWOIT     CLEARIT   99 45 ]Q !  777 SIZE 2/ ]Q ! ;  \ only 2 different records

: TURTLES   SIZE  0
            DO                  \ each 2 elements are reversed
               I I CHAR+ ]Q !
               I CHAR+ I ]Q !
            2 +LOOP ;

\ this macro makes the sort faster
: /1.3 ( N -- N ) S" 10 13 */  1 MAX " EVALUATE ;  IMMEDIATE

: 1+!  ( n addr -- ) 1 SWAP +! ;

: XCHG  ( ADR ADR -- )  OVER @  OVER @  SWAP ROT !  SWAP ! ;

: DESC-COMBSORT ( N -- )
    CR ." COMB SORT! "
    DUP ITEMS ! GAP !
    0 PASSES !
    BEGIN
        GAP @  /1.3  GAP !                 \ additional line
        SFLAG ON
        ITEMS @  GAP @ -  0
        DO
           I GAP @ + ]Q @   I ]Q @  >
           IF
              I GAP @ + ]Q   I ]Q  XCHG2
              SFLAG OFF
           THEN
        LOOP
        PASSES 1+!
       SFLAG @  GAP @ 1 = AND             \ additional conditional
   UNTIL ;

: COMBIT
    SIZE DESC-COMBSORT
    CR ." Combsort complete in " PASSES ?  ."  PASSES" CR  .S ;

