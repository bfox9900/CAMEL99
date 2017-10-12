( RE-ENTRANT STRING LEXICON                    OCT 8 1987 Brian Fox)
\ re-write for CAMEL99 AUG 28 2017

\ Written orginally to provide TI-BASIC string functions for TI-Forth.
\ I have re-written it many times; for HsForth GForth, MPE Power Forth,
\ Mark re-invented it for Turbo Forth and now I have re-written it for CAMEL99.

\ New Concept:
\ Input strings are manipulated by ONLY moving pointers using addr,len.

\ Functions that output a string copy their result onto a string stack.
\ The address of the output string is on the Forth Parameter stack.
\ This allows string functions to feed into another string function.

\                --THE SECRET SAUCE --
\ Two functions, PUT and PRINT, collapse the string stack automatically.
\ This cleans up the intermediate strings that are created as you use the
\ string functions after you either store or print the final result.
\ No garbage collection required.

\ original version used run-time size checking.
\ It's removed here for more speed so be careful


DECIMAL
\ string stack ====
         VARIABLE SSP     \ the string stack pointer
     255 CONSTANT MXLEN   \ 255 bytes is longest string
MXLEN 1+ CONSTANT SSW     \ width of string stack items

: NEW:     ( -- ) SSW SSP +! ;  \ bump the string stack pointer by 256
: COLLAPSE ( -- ) SSP OFF  ;    \ reset string stack pointer to zero
: TOP$     ( -- ) SSP @ PAD + ;

\ From Wil Baden's Tool Belt [R.I.P. Wil] ====
: C+!         ( n addr -- )   DUP >R  C@ +  R> C! ;
: APPEND      ( addr n $ -- ) 2DUP 2>R  COUNT +  SWAP CMOVE 2R> C+! ;
\ : PLACE     ( addr n dst$ -- ) 2DUP C! 1+ SWAP CMOVE ;  \ in CAMEL99 Kernel
\ : APPEND-CHAR ( char caddr -- ) DUP >R COUNT DUP 1+ R> C! + C! ;

\ string stack helpers ====
: SPUSH    ( addr len -- top$ ) NEW: TOP$ DUP >R PLACE R> ;
: ?SSP     ( -- ) SSP @ 0= ABORT" Empty $ stack" ;
: DROP$    ( -- ) ?SSP MXLEN NEGATE SSP +! ;

\ Replicate TI-BASIC string functions ====
: LEN      ( $ -- n )  C@ ;
: SEG$     ( $ n1 n2 -- top$) >R >R COUNT R> 1- /STRING DROP R> SPUSH ;
: STR$     ( n -- top$)  DUP ABS S>D <# #S ROT SIGN #> SPUSH ;
: VAL$     ( adr$ - # )  ?NUMBER 0= ABORT" VAL$ err"  ;
: CHR$     ( ascii# -- top$ ) NEW: TOP$ 1 OVER C! SWAP OVER 1+ C! ;
: ASC      ( $ -- c)   1+ C@ ;

: &        ( $1 $2 -- top$)   \ concatenate operator
           SWAP COUNT SPUSH >R COUNT R@ APPEND R>  ; \ A$ B$ &  PRINT

: POS$    ( $1 $2 -- $1 $2 n )     \ return "position" of $1 in $2
           DUP -ROT                \ copy $2 under the inputs
           COUNT BOUNDS            \ step $2 char by char
           DO
             I OVER COUNT S=       \ S= part of CAMEL Forth.
             0= IF I LEAVE THEN    \ if 0 we found a match
           LOOP
           NIP SWAP -  ;           \ subtract addresses to get position

: LEFT$    ( $ n -- top$)     >R COUNT DROP R> SPUSH ;
: RIGHT$   ( $ n -- top$)     >R COUNT DUP R> - 0 MAX /STRING SPUSH ;

: COPY$    ( $1 $2 -- )       >R COUNT R> PLACE ;

: RPT$     ( $1 u -- top$)
            NEW:
            SWAP COUNT ROT
            0 ?DO
                2DUP TOP$ LEN OVER + SSW > ABORT" RPT$>255"
                TOP$ APPEND
            LOOP
            2DROP
            TOP$ ;

: CPOS   ( char $ -- ?) COUNT ROT SCAN NIP  ;  \ much faster char position

\ compare strings also use S=
: COMPARE$ ( $1 $2 -- flag)  OVER LEN 1+ S= ;
: =$       ( $1 $1 -- flag)  COMPARE$ 0= ;
\ : >$       ( $1 $2 -- flag)  COMPARE$ 0> ;  \ $1 > $2
\ : <$       ( $1 $2 -- flag)  COMPARE$ 0< ;  \ $1 < $2

( compile time string assignment)
: ="       ( $addr -- <text> )  [CHAR] " PARSE ROT PLACE ;
: =""      ( $addr -- ) 0 SWAP C! ;   \ sets string length to zero

\ string variables need DIM to allocate more space
: DIM      ( n -- ) DUP MXLEN > ABORT" Too big!"
                    ALLOT ;

: PUT      ( $1 $2 -- ) COPY$ COLLAPSE ;

: PRINT    ( $1 -- )   CR COUNT TYPE COLLAPSE ;       \ print on new line, clean $stack

: (")      ( -- ) R> DUP COUNT + ALIGNED >R ; \ advance IP on Rstack, past end of string

: "        ( -- )
           STATE @                          \ are we compiling?
           IF    COMPILE (") ,"             \ action when Compiled
           ELSE  [CHAR] " PARSE SPUSH       \ action when interpreted
           THEN ; IMMEDIATE

COLLAPSE  ( initializes the string stack)

( 768 bytes)
