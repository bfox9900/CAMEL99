 \ Quasi-particles by sometimes99er
 \ Converted to Camel99 MultiForth
 
 \ INCLUDE GRAFIX2.FTH    \ some day I will have files working
 \ INCLUDE SPRITES.FTH
 \ INCLUDE RANDOM.FTH

\ 100 CALL CLEAR::CALL SCREEN(5)::FOR A=5 TO 12::CALL COLOR(A,16,1)::NEXT A
\ 110 N$="00030C0F30333C3FC0C300000000000000CCCFF0F3FCFF"::FOR A=65 TO 90
\ 120 CALL CHARPAT(A,C$)::PRINT CHR$(A)&CHR$(A+32);::FOR C=0 TO 1:: D$=""
\ 130 FOR R=0 TO 7::D$=D$&SEG$(N$,(ASC(SEG$(C$,C+R*2+1,1))-48)*2+1,2)::NEXT R
\ 140 CALL CHAR(A+C*32,D$)::NEXT C::NEXT A::PRINT::PRINT::N$="QUASIPARTICLES"
\ 150 FOR A=1 TO LEN(N$)::PRINT SEG$(N$,A,1)&CHR$(ASC(SEG$(N$,A,1))+32);::NEXT A
\ 160 FOR A=1 TO 28::CALL SPRITE(#A,46,16,1,124,8,RND*10-5)::NEXT A::GOTO 160

\ Extended BASIC does all this for you with ISR code
\ ------------------------------------------------
INIT-MULTI  \ must do this before invoking any Multi-tasker word

: TASK:   CREATE  USIZE ALLOT ;    \ makes the code look nicer

\ create and init the task blocks
TASK: AUTOMOTION          \ create mem block for the task
      AUTOMOTION FORK     \ copy the current task into AUTOMOTION but with new stacks

: SPMOVER   ( -- )  \ this does the ISR job for us
       BEGIN
          SP.MOVE  \ updates position of all sprites & write to VDP
          28 MS    \ approximate update speed of TI-ISR
       AGAIN ;     \ run forever

' SPMOVER  AUTOMOTION ASSIGN  \ give AUTOMOTION the SPMOVER job

\ -----------------------------------------------
\ Program starts here

DECIMAL
29 CONSTANT N    \ number of PARTICLES we will create

\ random horizontal velocity ( -2 to -2 )
: RHORZ  ( -- +/- 5)  3 RND 1- ;

\ debugging words
\ : .RANDS  20 0  DO   CR  I .  ."   "  RHORZ .  LOOP ;
\ : .VECTORS   29 0 DO CR  I ]MOTION 2@  . SPACE .  LOOP ;

: PARTICLES ( n -- ) \ create 'n' particle sprites
    0
    ?DO
    \ clr    chr      Y    X   #
      16  [CHAR] .   128   0   I SPRITE
    LOOP ;


\ And what the heck. Let's put the quasi particles in their own task
TASK: SPRAYER
      SPRAYER FORK

 \ releases particles
VARIABLE SPEED  90 SPEED !

: QUASI ( -- )
       BEGIN
          N 0 DO                  \ for all the particles
            128 0 I LOCATE        \ locate sprite at top of screen
            12 MS
            RHORZ 2  I MOTION     \ set in motion downward at random angle
            SPEED @  MS           \ wait before shooting the next one.
         LOOP
       AGAIN ;

' QUASI SPRAYER ASSIGN

CLEAR

5 SCREEN

N PARTICLES

 MULTI

\ AUTOMOTION WAKE
