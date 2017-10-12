\ CODE.FTH let's you make machine code words
\ **these words are also contained in ASM9900.FTH**
\ for use with the assembler

: CODE      ( -- )  HEADER  HERE >BODY , !CSP ;
: NEXT,     ( -- )  045A , ;  \ B *R10
: ENDCODE  ( -- )  ?CSP  ;

\ *** ;CODE is part of the CAMEL99 KERNEL ***
\ : ;CODE
\    POSTPONE (;CODE)     \ compiles (;CODE) into definition
\    ?CSP POSTPONE [      \ turns off the Forth compiler
\    REVEAL               \ (just like ";" does)
\    ; IMMEDIATE          \ this is an IMMEDIATE word
    
\ Usage: 

\ HEX
\ CODE !  ( n addr -- )
\      C536 , C136 ,
\      NEXT,
\ ENDCODE

