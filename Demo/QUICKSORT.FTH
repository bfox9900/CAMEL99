\ QUICKSORT From Rossetta Code with test framework by B Fox

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
1000 CONSTANT SIZE

CREATE Q   SIZE CELLS CELL+ ALLOT

\ CODE []  ( n addr -- addr[n])  INLINE[ SWAP 2* + ] NEXT, END-CODE
\ : ]Q   ( n -- adr) Q INLINE[ SWAP 2* + ] ;

\ : ]Q  ( n -- adr) CELLS Q + ;   \ this is faster than using DOES>

 : ]Q    S" 2* Q + "  EVALUATE ;  IMMEDIATE

: ERASE   0 FILL ;

\ macros for words used by Quicksort author
: -CELL   S" -2" EVALUATE ; IMMEDIATE
: CELL+   S" 2+" EVALUATE ; IMMEDIATE
: CELL-   S" 2-" EVALUATE ; IMMEDIATE

: <=      S" 1+ <" EVALUATE ;  IMMEDIATE

: MID ( l r -- mid ) OVER - 2/ -CELL AND + ;

\ : EXCH ( addr1 addr2 -- ) DUP @ >R OVER @ SWAP ! R> SWAP ! ;
: EXCH        OVER @ OVER @ SWAP ROT ! SWAP ! ;

: PARTITION ( l r -- l r r2 l2 )
  2DUP MID @ >R ( r: pivot )
  2DUP
  BEGIN
    SWAP BEGIN  DUP @  R@  < WHILE CELL+ REPEAT
    SWAP BEGIN  R@ OVER @  < WHILE CELL- REPEAT
    2DUP <= IF 2DUP EXCH  >R CELL+ R> CELL-  THEN
    2DUP >
  UNTIL
  R> DROP ;

: QSORT ( l r -- )
  PARTITION  SWAP ROT
  2DUP < IF RECURSE ELSE 2DROP THEN
  2DUP < IF RECURSE ELSE 2DROP THEN ;

: SORT ( array len -- )
  DUP 2 < IF 2DROP EXIT THEN  1- CELLS OVER + QSORT ;

: QUICKSORT CR ." QUICKSORT!"    Q SIZE SORT ;

\ ============ TESTING COMMANDS ======================
\ load the array with different kinds of mixed up data
: CLEARIT  ( -- ) 0 ]Q SIZE CELLS ERASE ;     \ all the same data
: FILLIT   ( -- ) SIZE  0 DO   I  I ]Q !      LOOP ;
: DESCENDING   ( -- ) SIZE  0 DO  SIZE I -  I ]Q !  LOOP ;
: RANDIT   ( -- ) SIZE  0 DO  32000 RND I ]Q !   LOOP ;
: TWOIT    ( -- ) CLEARIT   99 45 ]Q !  777 SIZE 2/ ]Q ! ;  \ only 2 different records
: TURTLES  ( -- )
           SIZE 0
            DO
               I I CHAR+ ]Q !   \ each 2 elements are reversed
               I CHAR+ I ]Q !
            2 +LOOP ;

\ use this to print the array (use FNCT 4 to break out (ALT 4 on PC)
: SEEIT   ( -- ) CR  SIZE  0 DO  I ]Q @ U. ?BREAK  LOOP ;
\ ===================================================
