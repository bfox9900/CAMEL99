( VALUEs for CAMEL99 )

: >BODY    2+ ;

: VALUE   CONSTANT ;

: (TO)    ( n cfa -- ) >BODY ! ;

: TO      ( n -- )
           STATE @
           IF   [COMPILE] [']  COMPILE (TO)
           ELSE '  (TO)
           THEN ; IMMEDIATE
