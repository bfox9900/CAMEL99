\ TI LOGO GRAPHICS  chars patterns from Soemtimes88er
GRAPHICS

DECIMAL
08 CONSTANT B/CHAR  \ bytes per char

HEX
CREATE TI-LOGO
       0103 , 0303 , 0303 , 0303 ,   \ 1st char
       FC04 , 0505 , 0406 , 020C ,
       0080 , 4040 , 8000 , 0C12 ,
       FF80 , C040 , 6038 , 1C0E ,   \ 4th char
       1921 , 213D , 0505 , 05C4 ,
       BA8A , 8ABA , A1A1 , A122 ,
       0301 , 0000 , 0000 , 0000 ,
       E231 , 1018 , 0C07 , 0300 ,
       4C90 , 2040 , 4020 , E000 ,

DECIMAL
: CHARBLOCK ( addr ascii cnt -- )   \ write cnt x 8 bytes to PDT in VDP
            8* >R ]PDT  R> VWRITE ;


\ TI-LOGO 128 9 CHARBLOCK  \ write pattern descriptor table

15 2 15 COLOR
16 2 15 COLOR
17 2 15 COLOR

: 3EMIT   ( char -- ) 3 0 DO  I OVER + EMIT  LOOP DROP ;

: TI.LOGO ( -- )
          VCOL @ VROW @
                           128 3EMIT
          2DUP 1+    AT-XY 131 3EMIT
          2DUP CELL+ AT-XY 134 3EMIT
          SWAP 3 + SWAP AT-XY ;


: LOGOLINE  PAGE 10 0 DO  TI.LOGO   LOOP  CR CR CR CR ;

