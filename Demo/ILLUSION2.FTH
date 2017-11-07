\ classic pipe & bar illusion by sometimes99er on Atariage

\ 100 call clear::call char(48,"01020408102040808040201008040201808080808080808080C0A09088848281")
\ 110 call char(52,"814224181020408003020408F",54,"E01008040402020201020408081010101008080403")
\ 120 for l=5 to 19::read c,s$::display at(l,c):s$; ::next l::for l=0 to 9^9::next l
\ 130 data 17,01,16,0  1,15,0 03 1,14,0 0 21 1,13,0 0 010 02,12,0 0 0 0 0 2,11,0 0 0 0 0 0,10
\ 140 data 0 0 0 0 0 0,9,0 0 0 0 0 0,8,760 0 0 0 0,8,85 0 0 0 0,10,760 0 0,10,85 0 0,12,760,12,85

GRAPHICS
HEX
CREATE SHAPES
       0102 , 0408 , 1020 , 4080 ,
       8040 , 2010 , 0804 , 0201 ,
       8080 , 8080 , 8080 , 8080 ,
       80C0 , A090 , 8884 , 8281 ,
       8142 , 2418 , 1020 , 4080 ,
       0302 , 0408 , F000 , 0000 ,
       E010 , 0804 , 0402 , 0202 ,
       0102 , 0408 , 0810 , 1010 ,
       1008 , 0804 , 0300 , 0000 ,

\ write character definitions to VDP RAM all at once
: CHARACTERS ( 'pattern ascii# char-cnt   -- ) 8* SWAP ]PDT SWAP VWRITE ;

DECIMAL
SHAPES  CHAR 0   9 CHARACTERS

: RUN  PAGE
       CR ."                01"
       CR ."               0  1"
       CR ."              0 03 1"
       CR ."             0 0 21 1"
       CR ."            0 0 010 02"
       CR ."           0 0 0 0 0 2"
       CR ."          0 0 0 0 0 0"
       CR ."         0 0 0 0 0 0"
       CR ."        0 0 0 0 0 0"
       CR ."       760 0 0 0 0 "
       CR ."       85 0 0 0 0"
       CR ."         760 0 0"
       CR ."         85 0 0"
       CR ."           760"
       CR ."           85"
       BEGIN KEY? UNTIL ;
       
: RUN2 PAGE
       CR
       CR
       CR  15 SPACES ." 01"
       CR  14 SPACES ." 0  1"
       CR  13 SPACES ." 0 03 1"
       CR  12 SPACES ." 0 0 21 1"
       CR  11 SPACES ." 0 0 010 02"
       CR  10 SPACES ." 0 0 0 0 0 2"
       CR  09 SPACES ." 0 0 0 0 0 0"
       CR  08 SPACES ." 0 0 0 0 0 0"
       CR  07 SPACES ." 0 0 0 0 0 0"
       CR  06 SPACES ." 760 0 0 0 0 "
       CR  06 SPACES ." 85 0 0 0 0"
       CR  08 SPACES ." 760 0 0"
       CR  08 SPACES ." 85 0 0"
       CR  10 SPACES ." 760"
       CR  10 SPACES ." 85"
       BEGIN KEY? UNTIL ;

CLEAR

       
