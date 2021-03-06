\ 99 bottles of beer.  Create a beer language and write the program

DECIMAL
: CASE    ( -- 0 )  0  ; IMMEDIATE
: OF      ( -- )   POSTPONE OVER   POSTPONE =   POSTPONE IF  POSTPONE DROP  ; IMMEDIATE
: ENDOF   ( -- )   POSTPONE ELSE ; IMMEDIATE
: ENDCASE ( -- )   POSTPONE DROP   BEGIN ?DUP WHILE  POSTPONE THEN   REPEAT ; IMMEDIATE

: BOTTLES ( n -- )
        DUP
        CASE
         1 OF    ." One more bottle " DROP ENDOF
         0 OF    ." NO MORE bottles " DROP ENDOF
                 . ." bottles "    \ DEFAULT CASE
        ENDCASE ;

: ,   [CHAR] , EMIT  SPACE 100 MS CR ;
: .   [CHAR] . EMIT  300 MS  CR CR CR ;

: HANGOVER    ." :-("  CR QUIT ;

: OF       ." of "   ;
: BEER     ." beer " ;
: ON       ." on "   ;
: THE      ." the "  ;
: WALL     ." wall" ;
: TAKE     ." take " ;
: ONE      ." one "  ;
: DOWN     ." down, " ;
: PASS     ." pass " ;
: IT       ." it "   ;
: AROUND   ." around" ;

: POPONE    1 SWAP CR ;
: DRINK     POSTPONE DO ; IMMEDIATE
: ANOTHER   POSTPONE -1  POSTPONE +LOOP ; IMMEDIATE
: HOWMANY   S" I " EVALUATE ; IMMEDIATE
: ONELESS   S" I 1- " EVALUATE ; IMMEDIATE
: BINARY    2 BASE ! ; 

: BEERS ( n -- )   \ Usage:  99 BEERS
      POPONE
      DRINK
         HOWMANY BOTTLES OF BEER ON THE WALL ,
         HOWMANY BOTTLES OF BEER ,
         TAKE ONE DOWN PASS IT AROUND ,
         ONELESS BOTTLES OF BEER ON THE WALL .
      ANOTHER 
      HANGOVER ;



