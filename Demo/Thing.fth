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
            768
            767 0
            DO
               '!' I VC!
               '*' OVER VC!
               ( n -- ) 1-
               ^C? IF GRAPHICS ." ^C" ABORT THEN
               200 MS
            LOOP
       AGAIN
;

THING
