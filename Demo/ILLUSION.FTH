\ optical illusion transated from BASIC
HEX
: C$  ( -- n n n n ) 00FF DUP DUP DUP ;   \     c$=rpt$("00FF",4)

DECIMAL
: RPT ( char n -- )    0 ?DO  DUP EMIT LOOP DROP ;

: .HP$ ( -- ) 2 SPACES  [CHAR] H 14 RPT  [CHAR] P 14 RPT ;  \ 110 c$=rpt$("H",14)&rpt$("P",14)
: .XP$ ( -- ) 2 SPACES  [CHAR] X 14 RPT  [CHAR] H 14 RPT ;  \     d$=rpt$("X",14)&seg$(c$,1,14)

: RUN
     PAGE  1 SCREEN               \ 100 call clear call screen(1)
     9 12 1 1 COLORS              \     call color(6,1,1,7,1,1,8,1,1)
     C$ 72 CHARDEF  C$ 80 CHARDEF  C$ 88 CHARDEF \ call char(72,c$,80,c$,88,c$)

     14 0 DO  .HP$ CR LOOP      \ for i=0 to 11
     11 0 DO  .XP$ CR LOOP      \ display at(i+1,1):c$;
     .XP$                       \ display at(i+13,1):d$;
                                 \ next i
     9  14 11 COLOR             \ 120 call color(6,14,11,7,8,14,8,8,11)
     10  8 14 COLOR
     11  8 11 COLOR
     2000 MS  ;

: COLOR_WHEEL
 BEGIN
     20 0 DO
            9  10 11 COLOR
            150 MS
            9  14 11 COLOR
     LOOP

     20 0 DO
            10  8  4 COLOR
            11  8 10 COLOR
            150 MS
            10  8 14 COLOR
            11  8 11 COLOR
     LOOP
     KEY?
 UNTIL  ;

 GRAPHICS