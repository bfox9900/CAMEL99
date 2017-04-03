( RE-ENTRANT STRING LEXICON                    OCT 8 1987 Brian Fox)
( *798 BYTES* )
( Written orginally to provide string functions like BASIC in      )
( TI-Forth.  I have re-written it many times;       for HsForth    )
( GForth, MPE Power Forth, Mark re-invented it for Turbo Forth and )
( now back to the TI-99 for CAMEL99.                               )

( Concept: All string functions return a counted string address on )
(           the Forth parameter stack.  That address is the TOP$   )
(           of the string stack when the function completes        )

( original version used run-time size checking.)
( It's removed now for speed so be careful)

( ** Since 1987 Forth developers have learned that processing a    )
( string on the stack as an address,length combination gives you   )
( amazing simplicity to cut strings so this new code reflects that )
( using assembler words called /STRING SKIP and SCAN in CAMEL Forth)

( INCLUDE LOOPS )

DECIMAL
( build a string stack )
      VARIABLE SSP     ( this is the string stack pointer     )
  256 CONSTANT MXLEN   ( string can't be bigger than 256 bytes)

: NEW:     ( -- ) MXLEN SSP +! ; ( bump the string stack pointer by 256)
: COLLAPSE ( -- ) SSP OFF ;      ( set SSP to zero)

( string stack uses unallocated Dictionary memory above Forth's PAD buffer)
: TOP$     ( -- ) SSP @ PAD + ;

( Operations we use to create higher level functions )
( From Wil Baden's Tool Belt [R.I.P.] )
: C+!         ( n addr -- )  DUP >R  C@ +  R> C! ;         ( increment a byte at addr. by n)
: APPEND      ( addr n $ -- ) 2DUP >R >R  COUNT +  SWAP CMOVE R> R> C+! ;
: APPEND-CHAR ( char caddr -- )  DUP >R  COUNT  DUP 1+ R> C!  +  C! ;
: STRPUSH     ( addr cnt -- top$ ) NEW: TOP$ PLACE TOP$ ;  ( Push addr/len string to string stack)

( functions to move strings)
: PUSH$     ( $ -- )     COUNT NEW: TOP$  PLACE ;
: POP$      ( $ -- )     TOP$ COUNT ROT PLACE DROP$ ;
: COPY$     ( $1 $2 -- ) >R COUNT R> PLACE ;

: ?SSP     ( -- ) SSP @ 0= ABORT" String stack underflow" ;
: DROP$    ( -- ) ?SSP MXLEN NEGATE SSP +! ;

( string variables require DIM )
( Example:  VARIABLE A$  25 DIM )
: DIM   ( n -- )    DUP MXLEN > ABORT" Too big!"  ALLOT ;

( now we can build the standard BASIC string functions )
: LEN      ( $ -- n )  C@ ;
: LEFT$    ( $ # -- top$) SWAP COUNT DROP SWAP STRPUSH ;
: RIGHT$   ( $ #  -- top$)  >R COUNT R> OVER MIN /STRING STRPUSH ;
: SEG$     ( $ start# char# -- top$) >R >R COUNT R> /STRING STRPUSH  R> TOP$ C!   ;
: CPOS$     ( $ char -- $ position)  >R PUSH$ TOP$ DUP COUNT 2DUP R> SCAN NIP - NIP 1+ ; ( 1st char is 1)
: STR$     ( n -- top$) 0 <# #S #>   STRPUSH ;
: VAL$     ( adr$ - # ) ?NUMBER 0= ABORT" VAL$ can't convert"  ;
: CHR$     ( ascii# -- top$ ) NEW: TOP$ 1 OVER C! 1+ C! ;

( concatenate 2 strings USAGE: A$ B$ ADD$ C$ PUT )
: ADD$       ( $1 $2 -- top$) SWAP PUSH$  COUNT TOP$ APPEND TOP$ ;

: COMPARE$   ( $1 $2 -- flag)  OVER LEN 1+ S= ;
: =$         ( $1 $1 -- flag)  COMPARE$ 0= ;
: >$         ( $1 $2 -- flag)  COMPARE$ 0> ;
: <$         ( $1 $2 -- flag)  COMPARE$ 0< ;

( and some that BASIC does not have )
: SKIP$    ( $ char -- $ ) >R COUNT R> SKIP STRPUSH ;  ( removes leading char)

( assign strings )
: ="       ( $addr -- <text> )  [CHAR] " WORD SWAP COPY$ ;
: =""      ( $addr -- ) OFF ;   ( don't erase, just set length to zero)
: WRITE$   ( $ -- )   CR COUNT TYPE ;

HEX
( string literal creation uses ANS Forth word C" )
( It has the unique feature that it works in immediate mode too)
: C"       ( -- )
            STATE @                         ( are we compiling?)
            IF     COMPILE ,"               ( action when Compiled )
            ELSE   22 PARSE STRPUSH   ( action when interpreted)
            THEN ; IMMEDIATE

(  --THE SECRET SAUCE to be as easy as BASIC--            )
(  ------------------------------------------------------ )
( The following words collapse the string stack after you )
( use them. This automatically cleans up the intermediate )
( strings that get created as you process strings         )
(     **THIS MEANS YOU DON'T WORRY ABOUT IT**             )



: PUT       ( $1 $2 -- ) COPY$ COLLAPSE ;

: PRINT     ( -- )       WRITE$ COLLAPSE ;



DECIMAL

( test code )
 VARIABLE A$  80 DIM
 VARIABLE B$  90 DIM
 VARIABLE C$ 200 DIM
 C" THIS IS STRING A$" A$ PUT
 C" LOOK FOR THE * IN THIS ONE" B$ PUT
 C$ =" This is the contents of the string called C$."

 B$ CHAR * CPOS$ LEFT$ PRINT
 B$ CHAR * CPOS$ RIGHT$ PRINT





