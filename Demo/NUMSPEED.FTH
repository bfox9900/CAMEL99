\ demonstrate printing a number in place on the screen

DECIMAL

: GO   ( -- )
       PAGE 
       0                        \ start with 0 on stack
       BEGIN
           12 12 AT-XY  DUP U.  \ print copy of the number
           1+                   \ increment the number
           KEY?                 \ reading all keys is SLOW (~0.9mS)
       UNTIL
       DROP ;

: GO2   ( -- )
       PAGE
       0                        \ start with 0 on stack
       BEGIN
           12 12 AT-XY  DUP U.  \ print copy of the number
           1+                   \ increment the number
           ^C?                  \ reading ^C is faster (~0.2mS)
       UNTIL
       DROP ;


\ faster number writer to video address
: V.U ( Vaddr n -- )  S>D  <#  #S  #>  VPOS SWAP  VWRITE ;

: GO3  ( -- )
       PAGE
       0                        \ start with 0 on stack
       BEGIN
           DUP V.U              \ print copy of the number
           1+                   \ increment the number
           ^C?                  \ reading ^C is faster (~0.2mS)
       UNTIL
       DROP ;

GRAPHICS  
     