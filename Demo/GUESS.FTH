\ Guess the number in CAMEL99 Forth

DECIMAL
VARIABLE GUESS#

HEX
83C0 CONSTANT SEED   \ RAM where TI has a number incrementing in main menu
1045 CONSTANT GEN#
: RNDW      ( -- N )   SEED @ GEN# UM* DROP 1+ DUP SEED ! ;
: RANDOMIZE ( N -- )   SEED ! ;
: RND       ( n -- n') RNDW ABS SWAP MOD ;

: ASK    ( -- )
         CR CR
         GUESS# @ 0=
         IF    ." Guess a number between 1 and 10: "
         ELSE  ." Try Again: "
         THEN ;

DECIMAL
: RANGE  ( n -- ? )
         1 11 WITHIN 0=
         IF CR ." That's not valid so... " THEN ;

: GUESS  ( -- n)
         PAD DUP 4 ACCEPT EVALUATE ;

: REPLY  ( the# guess -- n)
         DUP RANGE \ check if the guess is in range
         2DUP <> IF CR HONK ." No, it's not " DUP . THEN ;

: FINISH ( -- )
          CR
          CR BEEP 50 MS  BEEP ." Yes it was " .
          CR ." You got it in " GUESS# @ DUP .  1 = IF ." try!" ELSE ." tries!" THEN
          CR ;

: PLAYAGAIN
          CR ." **Type GAME to play again**"
          CR ;
HEX
: CYAN   17 7 VWTR ;

DECIMAL
: GAME ( -- )
          TEXT  CYAN
          0 GUESS# !
          10 RND 1+ ( -- rnd#)
          BEGIN
             ASK GUESS REPLY
            1 GUESS# +!
          OVER = UNTIL
          FINISH
          PLAYAGAIN ;

