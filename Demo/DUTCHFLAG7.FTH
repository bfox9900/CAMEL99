\ Dutch flag problem DEMO using combsort
\ *SORTS IN PLACE FROM VDP MEMORY*

GRAPHICS

HEX
83C0 CONSTANT SEED   \ RAM where TI has a number incrementing in main menu
1045 CONSTANT GEN#   \ GForth uses $10450405, we take the 1st 16 bits
: RNDW      ( -- n )   SEED @ GEN# UM* DROP 1+ DUP SEED ! ;
: RANDOMIZE ( n -- )   SEED ! ;
: RND       ( n -- n') RNDW ABS SWAP MOD ;

\ 83D6 CONSTANT SCRTMO  \ clear screen time-out

VARIABLE GAP
VARIABLE ITEMS
VARIABLE ADR
VARIABLE SFLAG

FFFF FFFF FFFF FFFF PATTERN: SQUARE
0F07 0F1D 3870 E0C0 PATTERN: ARROW

\ define colors and characters

DECIMAL
24 32 *  CONSTANT SIZE     \ flag will fill GRAPHICS screen
SIZE 3 / CONSTANT #256     \ 256 chars per segment of flag
1        CONSTANT REDSQR   \ red character
9        CONSTANT WHTSQR   \ white character
19       CONSTANT BLUSQR   \ blue character
28       CONSTANT PTR1

\ color constants
1        CONSTANT TRANS
7        CONSTANT RED
5        CONSTANT BLU
16       CONSTANT WHT

SQUARE REDSQR CHARDEF
SQUARE BLUSQR CHARDEF
SQUARE WHTSQR CHARDEF
SQUARE PTR1   CHARDEF

\ charset  FG    BG
  0        RED TRANS COLOR
  1        WHT TRANS COLOR
  2        BLU TRANS COLOR

\ screen fillers
: RNDI    ( -- n ) SIZE 1+ RND ; \ return a random VDP screen address

: NOTRED    (  -- n ) \ return rnd index that is not RED
           BEGIN  RNDI DUP VC@ REDSQR = WHILE DROP  REPEAT ;

: RNDRED  (  -- ) \ Random RED on VDP screen
          #256  0 DO  REDSQR NOTRED VC!  LOOP ;

: NOTREDWHT    ( -- n ) \ return rnd index that is not RED or BLU
           BEGIN  RNDI DUP
              VC@  DUP REDSQR =  SWAP WHTSQR = OR
           WHILE
              DROP
           REPEAT ;

: RNDWHT (  -- ) \ place white where there is no red or white
          #256 0 DO  WHTSQR NOTREDWHT VC!  LOOP ;

: BLUSCREEN ( -- )  0 768 BLUSQR VFILL ;
        \  SIZE 0 DO
        \      I VC@ BL =
        \      IF  BLUSQR I VC!   THEN
        \  LOOP ;

\ load the screen with random red,white&blue squares
: RNDSCREEN   ( -- )  BLUSCREEN  RNDRED  RNDWHT ;

: BLUWHTRED  ( -- )
         SIZE 0
         DO
              BLUSQR I VC!
              WHTSQR I 1+ VC!
              REDSQR I 2+ VC!
         3 +LOOP ;

: RUSSIAN  \ Russian flag
            0  0 WHTSQR 256 HCHAR
            0  8 BLUSQR 256 HCHAR
            0 16 REDSQR 256 HCHAR ;

: DUTCH   \ Dutch National Flag   \ test for sort stability
            0  0 REDSQR 256 HCHAR
            0  8 WHTSQR 256 HCHAR
            0 16 BLUSQR 256 HCHAR ;

: FRENCH  \ kind of French flag
           0  0 BLUSQR 256 VCHAR
          10 15 WHTSQR 256 VCHAR
          21  7 REDSQR 256 VCHAR ;

\ These macros remove a call to this code
: /1.3  ( n -- n/1.35 ) \ 100/135 is fastest GAP  ratio for this sort
        S" 100 135 */ 1 MAX " EVALUATE ;  IMMEDIATE

: XCHG  ( adr1 adr2 CHAR1 CHAR2 -- ) 
        S" SWAP ROT VC! SWAP VC!" EVALUATE ;  IMMEDIATE

: COMBSORT (  -- )
    SIZE DUP  GAP !
    BEGIN
        GAP @  /1.3  GAP !  \ calc. new gap
        SFLAG ON
        DUP GAP @ -  0
        DO                   ( **stack state**)
           I DUP GAP @ +     ( -- adr1 adr2)
           OVER VC@ OVER VC@ ( -- adr1 adr2 c1 c2)
           2DUP >            ( -- adr1 adr2 c1 c2)
           IF
              XCHG           ( -- )
              SFLAG OFF
           ELSE
              2DROP 2DROP    ( -- )
           THEN
        LOOP
        SFLAG @  GAP @ 1 = AND            \ additional conditional
    UNTIL
    DROP ;

: BUBBLE (  -- )
    BEGIN
        SFLAG ON
        SIZE 1- 0
        DO                   ( **stack state**)
           I DUP 1+     ( -- adr1 adr2)
           OVER VC@ OVER VC@ ( -- adr1 adr2 c1 c2)
           2DUP >            ( -- adr1 adr2 c1 c2)
           IF
              XCHG           ( -- )
              SFLAG OFF
           ELSE
              2DROP 2DROP    ( -- )
           THEN
        LOOP
        SFLAG @
    UNTIL
    DROP ;


: BEEPS   0 ?DO  BEEP 1000 MS  LOOP ;

: RUN ( -- )
         RNDSCREEN  3 BEEPS COMBSORT HONK
         BLUWHTRED  3 BEEPS COMBSORT HONK
         RUSSIAN    3 BEEPS COMBSORT HONK
         FRENCH     3 BEEPS COMBSORT HONK
         CR ." Completed"  ;

