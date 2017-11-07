\ Sieve of Erathosenes in Forth using a VALUE as array pointer
\ Tested with TurboForth and CAMEL99 Forth

0 VALUE SIEVE[]           \ holds array address

\ array calculators
CODE []@ ( n addr -- ? ) INLINE[  + C@ ] NEXT, END-CODE
CODE []! ( n addr -- )   INLINE[  + C! ] NEXT, END-CODE

CODE NDX ( n n  -- n n ) INLINE[  2DUP DUP * ] NEXT, END-CODE

: SIEVE[]@ ( n -- ? ) SIEVE[] []@  ;
: SIEVE[]! ( n -- )   SIEVE[] []!  ;

: ERASE  ( addr n -- ) 0 FILL ;

HEX
: FREEMEM  ( -- n) FF00 HERE - ;

: ?MEM     ( n -- n )  FREEMEM OVER < ABORT" Out of memory" ;

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
           NDX >
        WHILE
           DUP SIEVE[]@ 0=
           IF  NDX
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

\ 10000 primes              w/ []@
\ TF               7.7
\ CAMEL99 ITC      8.4      8
\ CAMEL99 DTC      7.5


