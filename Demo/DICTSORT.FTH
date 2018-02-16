\ sort dictionary words experiment

HEX

VARIABLE SFLAG
VARIABLE ITEMS
VARIABLE GAP
VARIABLE PASSES

200 CELLS MALLOC CONSTANT DATA[]   \ create a data array in HEAP

: ]DATA    ( n -- addr ) CELLS DATA[] + ; \ index into DATA[]

\ put n in the next data[] record & bump the items counter
: DATA,   ( n -- )  ITEMS @ ]DATA !  1 ITEMS +!  ;

: NFAS    ( -- addr n )  \ load the NFAs of all words into DATA[]
          CR ." Loading NFAs..."
          2000 HP !         \ set the heap address back to beginning
             ITEMS OFF      \ reset data pointer
             CR
             0          ( word counter on stack)
             LATEST @
             BEGIN  PAUSE
                DUP  DATA,        \ compile nfa into heap memory
                SWAP CHAR+ SWAP   ( -- cntr addr )
                NFA>LFA @ DUP
                ?BREAK
             0= UNTIL
             DROP . ." words" ;

\ compare strings also use S=
: COMPARE$ ( $1 $2 -- flag)  1+ SWAP COUNT S= ;
: =$       ( $1 $1 -- flag)  COMPARE$ 0= ;
: >$       ( $1 $2 -- flag)  COMPARE$ 0> ;  \ $1 > $2
: <$       ( $1 $2 -- flag)  COMPARE$ 0< ;  \ $1 < $2

: /1.3 ( N -- N )   10 13 */  1 MAX  ;
: 1+!  ( n addr -- ) 1 SWAP +! ;

: XCHG  ( ADR ADR -- )   OVER @  OVER @  SWAP ROT !  SWAP ! ;

: $.     COUNT TYPE SPACE  ;

: .PAIR  ( ADR ADR -- ) $.  SWAP $. ;

\ display the words in sorted order
: S.WORDS   ITEMS @ 0 DO   I ]DATA @ $.  ?BREAK  LOOP ;

: SORTWORDS ( -- )
    NFAS
    CR ." Sorting "
    ITEMS @ GAP !
    BEGIN
        GAP @  /1.3  GAP !                 \ additional line
        SFLAG ON
        ITEMS @  GAP @ -  0
        DO
           I GAP @ + ]DATA @   I ]DATA @  <$
           IF
              I GAP @ + ]DATA   I ]DATA  XCHG
              SFLAG OFF
           THEN
        LOOP [CHAR] . EMIT
       SFLAG @  GAP @ 1 = AND             \ additional conditional
    UNTIL
    CR S.WORDS ;


