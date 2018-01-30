\ ========================================================================
\ T O O L S  can be loaded onto the KERNEL99

HEX
\ bounds is just so handy and in ASSEMBLER
\ it is the same size as using 'OVER + SWAP' (6 bytes)
\ **moved to CODE**
\ : BOUNDS ( adr len -- adr2 adr1) OVER + SWAP ;

: MARKER  ( -- )
          LATEST @ HERE         \ get latest word NFA and location of HERE
          ALIGN                 \ align new word to even boundary
          CREATE  ,   ,         \  save here & latest
   
          DOES>  2@  LATEST ! DP ! ;

MARKER TOOLS

: ?          ( adr -- ) @ . ;

: DEPTH      ( -- n )   SP0 SP@ CELL+ - 2/ ;

\ .S is more ccmplicated with TOS in a register
: .S         ( -- ) ." |" DEPTH IF   0 DEPTH 2- DO   I PICK  U.  -1 +LOOP  THEN ;

\ ABORT if control C key is pressed
: ?BREAK    ( -- ) ?TERMINAL ABORT" >>BREAK<<" ;

: WORDS     ( -- )
             CR
             0         ( word counter on stack)
             LATEST @
             BEGIN
                DUP
                COUNT TYPE SPACE  \ camel forth NFA is clean :-)
                SWAP CHAR+ SWAP   ( -- cntr addr )
                NFA>LFA @ DUP
                ?BREAK
             0= UNTIL
             DROP
             CR U. SPACE ." words" ;

\ BFox DUMP looks like dos debug, but without segment address
\ modified for TI-99 40 column screen

: .####       ( n --)     0 <# # # # # #> TYPE ;

: .ASCII      ( adr n --)    \ print ascii values or '.' for non-printable chars
              BOUNDS
              DO
                 I C@ DUP
                 BL 1-  80 WITHIN      \ check for printable char (from SPACE to ASCII '~')
                 0= IF DROP  [CHAR] .  \ replace unprintable chars with '.'
                 THEN EMIT
              LOOP ;
DECIMAL

: ?80         ( -- 16 | 8)             \ test for 80 column mode, return columns
              VMODE @ 80 = IF 16 ELSE 8 THEN ;

HEX
: DUMP        ( offset n -- )
               BASE @ >R
               HEX
               BOUNDS                 \ 'I' is the address pointer
               DO PAUSE
                  CR @
                  I  .####  [CHAR] : EMIT                         \ print the adr
                  I  ?80  BOUNDS DO  SPACE I @ .#### 2 +LOOP SPACE  \ print 8 bytes of memory
                  I  ?80  .ASCII                                    \ print 8 ascii format BYTES
                  ?BREAK
               8 +LOOP                                            \ increment the offset address by 8
               CR 
               R> BASE ! ;
               
