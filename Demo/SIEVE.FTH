\ Sieve of Erathosenes in Forth
\ Tested with TurboForth and CAMEL99 Forth

\ array calculators
: []@ ( n addr -- ? )  + C@  ;
: []! ( n addr -- )    + C! ;

: ERASE  ( addr n -- ) 0 FILL ;

: SQRT ( n -- n ) -1 TUCK DO   2+ DUP  +LOOP   2/ ;

HEX
: FREEMEM  ( -- n) FF00 HERE - ;
: ?MEM     ( n -- )  FREEMEM OVER < ABORT" Out of memory" ;

\ byte array uses unallocated memory at HERE
DECIMAL
: PRIMES ( n -- )
        ?MEM
        CR ." Running..."
        HERE OVER ERASE
        1 0 HERE []!       \ mark as prime like 'C' version
        1 1 HERE []!
        2                  \ start at 2
        BEGIN
           2DUP DUP * >
        WHILE
           DUP HERE []@ 0=
           IF  2DUP DUP *
               DO
                  1 I HERE []!
               DUP +LOOP
           THEN
           1+
        REPEAT
        CR ." Complete."
        CR
        DROP
        ." Primes: " 2 DO  I HERE []@ 0= IF I . THEN  LOOP
;


\ 1000 primes
\ X BASIC         14.3 secs
\ TI BASIC        11.9

\ 10000 primes
\ TF               8.0
\ CAMEL99 ITC     10.28
\ CAMEL99 ITC      8.3    ( optimized HERE )
\ CAMEL99 DTC      7.25


