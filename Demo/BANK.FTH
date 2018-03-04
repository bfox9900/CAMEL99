\ data structures in SAMS mapped memory
HEX

3000 H !    \ move CAMEL99 heap 4K above the mapped area

     VARIABLE BANK#      \ current mapped bank
  10 CONSTANT 1STBANK    \ we don't use the lower 64K
1000 CONSTANT B/BANK     \ bytes per bank = 4K
2000 CONSTANT MBLOCK     \ mapped memory block used is >2000

HEX
: >BANK  ( 32bit -- addr)           \ must have 32bit address!!
         B/BANK UM/MOD  1STBANK +   ( -- offset bank#+1STBANK)
         BANK# @ OVER =             \ are we using the same bank#
         IF
              DROP                  \ Yes!. Drop the bank#

         ELSE                       \ No. MAP in a new bank
              DUP FF00 AND ABORT" Bank# Err!"
              DUP BANK# !           \ update bank#
              DUP FUSE              \ Hi & lo bytes are now identical

         \ compute SAMS register for address=MBLOCK at compile time
            [ MBLOCK 0B RSHIFT 4000 + ] LITERAL

              1E00 CRU! 0 SBO        \ enable SAMS card
            ( bank# register) !    \ store bank in SAMS register
              0 SBZ                  \ disable SAMS card
         THEN MBLOCK OR            \ return the address in mapped block
;

\ direct access to 900K memory space
: C@L    ( 32addr -- n)  >BANK C@ ;   \ fetch a byte
: C!L    ( n 32addr -- ) >BANK C! ;   \ store a byte

: @L     ( 32addr -- n)  >BANK @ ;    \ fetch an int
: !L     ( n 32addr -- ) >BANK ! ;    \ store an int

\ debug words
 : UD.    ( d -- )   <#  #S  #>  TYPE SPACE ;
 : ??     ( addr --) 2@ UD. ;

\ =====================================================
\ Create words to allow easy integration with 16 bit
\ CAMEL Forth universe
\ ---------------------------------

: D,     ( d -- )
         SWAP , ,  ;          \ compile a 32bit number into dictionary

\ We need a 32bit variable to keep track of 900K of memory
CREATE SAMS    0 0 D,

\ == simple memory manager ==
\ return the 32bit pointer to next available SAMS memory location
: SHERE   ( -- d)  SAMS 2@ ;

\ allocate n bytes in the SAMS memory space (max 64K)
: SALLOT  ( n -- ) SHERE ROT M+ SAMS 2! ;

\ == create some data type managers
: SAMS-INT: (  -- <text>)
\ compile time action:
           CREATE           \ create a word in dictionary
              SHERE D,      \ compile the 32bit SAMS location into the word
              2 SALLOT      \ allot 2 bytes of SAMS space

\ runtime action:  ( -- addr)
           DOES> 2@ >BANK ; \ fetch the 32bit from myself, convert to a bank address

: SAMS-BUFFER: ( n -- <text>) ( 4K is the largest practical buffer we can allocate)
\ compile time action:
           DUP B/BANK U> ABORT" >4K"
           CREATE           \ create a word in dictionary
              SHERE D,    \ compile the 32bit SAMS location into the word
              SALLOT        \ allot n bytes of SAMS space

\ runtime action: ( -- addr)
           DOES> 2@ >BANK ; \ fetch the 32bit from myself, convert to a bank address

: SAMS-ARRAY: ( n -- <text>)
\ compile time action:
           CREATE           \ create a word in dictionary
              SHERE D,      \ compile the 32bit SAMS location into the word
              CELLS SALLOT  \ allot n * 2 bytes of SAMS space (int = 2bytes)

\ runtime action:  ( n -- addr)
           DOES> 2@            \ fetch the 32bit base address from myself
                 ROT CELLS M+  \ rotate the index 'n' to top, multiply by cell size & add to base
                 >BANK ;       \ convert to a bank address

: SAMS-BYTES: ( n -- <text>) \ we can index upto 64K bytes (>FFFF)
\ compile time action:
           CREATE           \ create a word in dictionary
              SHERE D,      \ compile the 32bit SAMS location into the word
              SALLOT        \ allot n bytes of SAMS space

\ runtime action:  ( n -- addr)
           DOES> 2@            \ fetch the 32bit base address from myself
                 ROT M+        \ rotate the index 'n' to top, add to base
                 >BANK ;       \ convert to a bank address


\ ===========================================
\ example code

\ SAMS-INT: X
\ SAMS-INT: Y
\ SAMS-INT: Z

0400 CONSTANT 1K
1000 CONSTANT 4K
7FFF CONSTANT 32K
FFFF CONSTANT 64K


32K  SAMS-ARRAY: ]COWS
32K  SAMS-ARRAY: ]PIGS

\ fill a 32K cell array (ie: 64K bytes)
\ it takes longer because it works at DO/LOOP speed.
: FILLCOWS ( n -- )
        32K  0
        DO
           DUP I ]COWS !
        LOOP
        DROP ;

\ maximum bank switch test: 
\ copy ]COWS -> ]PIGS array 1 CELL at a time.
\ does a bank switch for each cell access.
\ painfully slow... SEE BELOW:
: COPYPIGS
        32K 0
        DO
            I ]COWS @  I ]PIGS !
        LOOP ;
        

\ these versions use the CODE word FILL to load 4k bytes at a time
\ at full CPU speed.

64K SAMS-BYTES: ]BYTES

: ERASE    ( adr cnt -- ) 0 FILL  ;
: 3RD    ( a b c -- a b c a) 2 PICK ;

: FASTFILL ( char -- )
           64K 0
           DO
               I  U.
               I ]BYTES 4K  3RD  FILL
           4K +LOOP
           DROP ;

: FASTERASE
           64K 0
           DO
               I ]BYTES 4K ERASE
           4K +LOOP ;



