\ Sieve of Erathosenes in Forth using a VALUE as array pointer
\ Tested with TurboForth and CAMEL99 Forth

0 VALUE SIEVE[]           \ holds array address

\ array calculators
: SIEVE[]@ ( n addr -- ? ) SIEVE[] + C@  ;
: SIEVE[]! ( n addr -- )   SIEVE[] + C! ;

: ERASE  ( addr n -- ) 0 FILL ;

: SQRT ( n -- n ) -1 TUCK DO   2+ DUP  +LOOP   2/ ;

HEX
: FREEMEM  ( -- n) FF00 HERE - ;

: ?MEM     ( n -- )  FREEMEM OVER < ABORT" Out of memory" ;

\ byte array uses unallocated memory at HERE
DECIMAL
: PRIMES ( n -- )
        ?MEM
        HERE TO SIEVE[]       \ assign address to the array

        CR ." Running..."
        SIEVE[] OVER ERASE
        1 0 SIEVE[]!          \ mark as prime like 'C' version
        1 1 SIEVE[]!
        2                     \ start at 2
        BEGIN
           2DUP DUP * >
        WHILE
           DUP SIEVE[]@ 0=
           IF  2DUP DUP *
               DO
                  1 I SIEVE[]!
               DUP +LOOP
           THEN
           1+
        REPEAT
        CR ." Complete."
        CR
        DROP
        ." Primes: " 2 DO  I SIEVE[]@ 0= IF I . THEN  LOOP
;

\ 10000 primes
\ TF               7.7
\ CAMEL99 ITC      8.4
\ CAMEL99 DTC      7.5


