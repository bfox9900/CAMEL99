\ inline.hsf  a simple speedup for ITC FORTH July 2017  B Fox

\ Premis:
\ An indirect threaded code (ITC) system can spend up to 50% of its time 
\ running the Forth thread interperpreter, typically called NEXT.
\ The ITC NEXT routine is three instructions on the TMS9900.
\ The Forth Kernel contains many words called primitives, that are coded in Assembler.
\ Many of these primitives are only 1 or 2 instructions.
\ INLINE[ ... ] copies the code from a primitive and compiles it in a new definition
\ but removes the call to NEXT at the end of each primitive.
\ This can double the speed of chains of CODE words.

\ **not portable code** 

HEX

: CODE        HEADER  HERE >BODY , !CSP ;
: ;CODE       (;CODE) !CSP ;  
: NEXT,       045A , ;        \ compile code for "B *R10"
: END-CODE    ?CSP  ;         \ check if any junk was left on the stack

\ ==============
\ TEST for CODE word
\ CFA of a code word contains the address of the next cell

: ?CODE ( cfa -- ) DUP @ 2- - ABORT" Not code word" ;  \ works only for ITC

\ scan MACHINE code looking for the NEXT, routine.
\ abort if NEXT is not found after 256 bytes. This is an arbitrary size
\ but most Forth code words are much smaller than 256 bytes.
: TONEXT ( adr --  adr2 )
           0                 \ this is a flag that falls thru if we don't succeed
           SWAP
          ( ADR) 80         \ max length of the allowed code word is $80 CELLS
           BOUNDS
           DO
             I @  045A   =   \ test each CELL for CAMEL99 NEXT (B *R10)
             IF   DROP I LEAVE
             THEN
           2 +LOOP
           DUP 0= ABORT" can't find NEXT" ;

\ : RANGE  ( cfa -- addr cnt )
\         >BODY DUP TONEXT OVER  -  ;  \ calc.  start and length of code fragment


: ASM[
           HERE CELL+ ,            \ compile a pointer to the next cell
           HERE CELL+ ,            \ which is the CFA of the inline code pointing to the next cell...
           [  ;  IMMEDIATE         \ switch OFF compiler and go to interpreter mode

: ]ASM     0209 ,  HERE 2 CELLS + ,  \ code macro:  LI R9,HERE+4  (moves Forth IP reg.)
           NEXT,
           ] ;   IMMEDIATE         \ switch ON compiler


: INLINE[
           POSTPONE ASM[
           BEGIN
             BL WORD COUNT PAD PLACE
             PAD CHAR+ C@ [CHAR] ] <>
           WHILE
             PAD FIND 0= ABORT" not found"
             DUP ?CODE 
             >BODY DUP TONEXT OVER  -     \ calc.  start and length of code fragment
             HERE OVER ALLOT SWAP CMOVE   \ transcribe the code to HERE
           REPEAT 
           POSTPONE ]ASM ;  IMMEDIATE

\ EXAMPLES
\ : *+       INLINE[ * + ]    ;
\ : DUPC@    INLINE[ DUP C@ ] ;
\ : DUP>R    INLINE[ DUP >R ] ;
\ : ^2       INLINE[ DUP *  ] ;


