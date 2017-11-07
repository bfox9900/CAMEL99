\  Waterfall by DRAGONSTOMPER translated to Forth by Lee Stewart

\ define chars 104 - 120
HEX
: CHR1     FFC7 BB7D FFFF FFFF 68 CHARDEF
           FF8F 77FA FFFF FFFF 69 CHARDEF
           FF1F EEF5 FFFF FFFF 6A CHARDEF
           FF3E DDEB FFFF FFFF 6B CHARDEF
           FF7C BBD7 FFFF FFFF 6C CHARDEF
           FFF8 77AF FFFF FFFF 6D CHARDEF
           FFF1 EE5F FFFF FFFF 6E CHARDEF
           FFE3 DDBE FFFF FFFF 6F CHARDEF
           FDFD FBDB DBBF BFBF 70 CHARDEF
           BFFD FDFB DBDB BFBF 71 CHARDEF
           BFBF FDFD FBDB DBBF 72 CHARDEF
           BFBF BFFD FDFB DBDB 73 CHARDEF
           DBBF BFBF FDFD FBDB 74 CHARDEF
           DBDB BFBF BFFD FDFB 75 CHARDEF
           FBDB DBBF BFBF FDFD 76 CHARDEF
           FDFB DBDB BFBF BFFD 77 CHARDEF
           4238 65D0 85D2 4D38 78 CHARDEF  ;
                                 
\ define chars 128 - 133
: CHR2
           0000 0307 0F0F 3F7F 80 CHARDEF    ( clouds)
           FFFF FFFF 7F0F 0000 81 CHARDEF    (  .    )
           0000 C0E0 F0F0 FCFE 82 CHARDEF    (  .    )
           FFFF FFFF FEF0 0000 83 CHARDEF    (  .    )
           0000 00C6 2810 0000 84 CHARDEF    ( bird  )
           0000 2854 8200 0000 85 CHARDEF ;  (  .    )

 
DECIMAL
 
\ "variables" ---
VARIABLE WATERPOS   \ current char pos for river and waterfall
VARIABLE BIRDPOS    \ current char pos for bird
VARIABLE BIRDCOL    \ current bird column
   
\ blank to black screen
: SCR_OFF   ( --- )
   1 SCREEN        
   3 16 1 1 COLORS ; \ *NEW SUB-PROGRAM: COLORS( set1,set2,fg,bg)

\ make drawn screen appear
\ CAMEL99 uses same color#s as BASIC
\ SET# computes the set number for any character value
: SCR_ON    ( --- )
    6 SCREEN        
    6    5   BL SET# COLOR  ( BL = 32 = space character)
    6   16  104 SET# COLOR
    6   16  112 SET# COLOR
    7   10  120 SET# COLOR
   16    1  128 SET# COLOR ; 

 
\ draw the ground
: GROUND    ( --- )
   23 5 DO                 \ loop rows 5 - 23
      15 I DUP .  16 120 HCHAR    \ draw row I
   LOOP  ;
 
\ toggle bird character (it will be 0 or 1)
: FLAP  ( --- )
   BIRDPOS @            \ get bird char pos
   1 XOR                \ toggle it to 1 or 0
   BIRDPOS  !           \ store new value in value
;
 
\  move bird column by 1 to 32 and wrap
 HEX
: BIRD+  ( --- )  
        BIRDCOL @   1+  1F AND BIRDCOL ! ;

DECIMAL
\ make bird fly
: FLY    ( --- )
   WATERPOS @ 0=             \ test for first water char
   IF                      \ fly bird only if on first water char
      FLAP                 \ flap wings  by changing char pattern
      BIRD+                \ move bird 1 col right
      0 3 32 32 HCHAR      \ clear bird from sky
      BIRDCOL 3 1          \ col, row, cnt
      132 BIRDPOS +        \ get bird char
      HCHAR                \ put bird back in sky at new position
   THEN   ;

 
\ advance char position for river and waterfall
: WATER+    ( --- )
   WATERPOS @ 1+          \ get water chars position and increment
   7 AND                  \ force to 0 - 7  (binary wrap method)
   WATERPOS ! ;            \ store new char position

 
\ draw water in next position
: WATER  ( --- )
   15 4 16 104 WATERPOS @ + HCHAR  \ draw top river
   14 4 19 112 WATERPOS @ + VCHAR  \ draw waterfall
   0 23 15 104 WATERPOS @ + HCHAR  \ draw bottom river
   FLY                             \ fly bird
   WATER+  ;                        \ increment water chars

 
\ draw a cloud
: CLOUD  ( col row --- )
   2DUP       
   1 128 HCHAR       \ draw top left of cloud
   OVER 1+ OVER      \ copy col; col + 1; copy row
   1 130 HCHAR       \ draw top right of cloud
   2DUP 1+           \ copy col & row; row + 1
   1 129 HCHAR       \ draw bottom left of cloud
   1+ SWAP 1+ SWAP   \ col + 1; row + 1
   1 131 HCHAR ;      \ draw bottom right of cloud

 
\ draw 4 clouds                                                                      2
: CLOUDS    ( --- )
    4 0 CLOUD        \ draw 1st cloud
    8 1 CLOUD        \ draw 2nd cloud
   16 1 CLOUD        \ draw 3rd cloud
   23 0 CLOUD ;       \ draw 4th cloud

 
\ set waterfall scene in motion
: WATERFALL    ( --- )
   GRAPHICS
   CLEAR   
   SCR_OFF  
   CHR1 CHR2
   GROUND  
   CLOUDS  
   WATER    
   SCR_ON  
   BEGIN    
      10 MS
      WATER
      KEY?  
   UNTIL  ;
