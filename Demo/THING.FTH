\ screen thing

DECIMAL
CHAR * CONSTANT '*'
CHAR ! CONSTANT '!'

: THING
       GRAPHICS
       BEGIN
            PAGE
            2 SCREEN
            '*' SET# 13 1 COLOR
            '!' SET# 7  1 COLOR
            767    \ last screen address on stack
            DUP 0
            DO
               '!'    I VC!  \ write directly to Video screen
               '*' OVER VC!  \ use last screen addr
               ( n -- ) 1-
               ?TERMINAL IF GRAPHICS ?BREAK THEN
               5 MS
            LOOP
            DROP
       AGAIN
;

\
\ **Type THING to start the demo

