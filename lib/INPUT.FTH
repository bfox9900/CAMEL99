\ INPUT.FTH   creates input like BASIC
\ *Difference* there is a separate input for numbers and strings

DECIMAL
: "?"      BEEP CR ." ?  " ;   \ we might want to reuse this gem

: $ACCEPT ( $addr -- )   DUP  1+ 80 ACCEPT  SWAP C!  ;

: $INPUT  ( $addr -- )  "?"  $ACCEPT ;  \ "?" to look like TI-BASIC

: #INPUT  ( variable -- )   \ made to look like TI-BASIC

          BEGIN
            PAD $INPUT       \ $ACCEPT text into temp buffer PAD
            PAD ?NUMBER 0=   \ convert the number in PAD
          WHILE              \ while the conversion is bad we do this
             CR HONK ." input error "
             CR DROP
          REPEAT
          SWAP ! ;           \ store the number in the variable on the stack)


\ Usage:

\ VARIABLE A$ 100 ALLOT      \ string variables need more space
\ VARIABLE X
\
\ A$ $INPUT

\ X  #INPUT