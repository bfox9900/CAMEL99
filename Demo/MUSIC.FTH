\ music lexicon to control TMS9919

\ INCLUDE SOUND.FTH  

DECIMAL
\ duration control variables and values
VARIABLE ON_TIME
VARIABLE OFF_TIME
VARIABLE FEEL        \ controls the on/off time ratio
VARIABLE TEMPO

  60 CONSTANT 
: TIMEBASE  ( -- d) 43392 3 ;           \ = 43392 3  ( double number)

: ATTENUATE ( n -- ) ATT @ OR SND! ;    \ faster than using DB

: BPM>MS    ( bpm -- ms)
            TIMEBASE ROT UM/MOD NIP ;   \ convert beats per minute to mS

: WHOLENOTE ( -- mS ) TEMPO @ BPM>MS ;  \ using tempo set the bpm for 1 whole note

: PLAY      ( fcode -- )
             ?BREAK                     \ halts if function 4 pressed
             OSC @ OR  SPLIT SND! SND!
             0 ATTENUATE  ON_TIME @ MS
            15 ATTENUATE OFF_TIME @ MS  ;

 \ Music needs notes to start and end in different ways.
 \ this word adjust the on:off ratio using n
: EXPRESSION ( note_dur n --)
           OVER SWAP -  TUCK -   ( -- on-ms off-ms )
           1 MAX OFF_TIME !  
           1 MAX ON_TIME ! ;                       \ store times in variables

: NOTE      ( -- MS ) ON_TIME @ OFF_TIME @ + ;           \ return full duration of current note

: DURATION!    ( MS -- )  FEEL @ EXPRESSION ;

: 5%       ( -- ) 5 / ;
: 10%      ( n -- n ) 10 / ;
: 20% ( n -- n ) 20 / ;
: 50%       ( N -- N/2)    2/ ;
: %         ( N N2  -- N%) 100 */ ;       \ calculate n2% of n
: 50%+      ( N -- N+50%)  DUP 50% + ;    \ dotted notes have 50% more time

: BPM       ( BPM -- )  \ set tempo in beats per minute
            TEMPO !      \ this patches a constant
            WHOLENOTE DURATION! ;

: NORMAL      NOTE 3 % FEEL ! ;
: LEGATO      NOTE 1 % FEEL ! ;     \ notes run together
: STACCATTO   NOTE 10 % FEEL ! ;  \ short notes
: MARCATO     NOTE  5 % FEEL ! ;  \ march feel

: RIT.     NOTE DUP 20% + DURATION! ;

: 1/1      WHOLENOTE      DURATION! ;
: 1/2      WHOLENOTE 50%  DURATION! ;
: 1/2.     1/2  NOTE 50%+ DURATION! ;
: 1/4      1/2  NOTE 50%  DURATION! ;
: 1/4.     1/4  NOTE 50%+ DURATION! ;
: 1/8      1/4  NOTE 50%  DURATION! ;
: 1/8.     1/8  NOTE 50%+ DURATION! ;
: 1/16     1/8  NOTE 50%  DURATION! ;
: 1/32     1/16 NOTE 50%  DURATION! ;
: REST     NOTE MS ;

\ note object creator
: NOTE:   ( freq -- )
           CREATE         \ compile time: create a name in the dictionary
                  >9919 , \ compile the 9919 code into the note

           DOES> @ PLAY ; \ run time:  fetch the number, play the note

\ FREQ  NATURAL    FREQ  ACCIDENTAL    EN-HARMONIC
\ -------------    ----------------   ----------------
  131 NOTE: C3     139 NOTE: C#3       : DB3 C#3 ;
  147 NOTE: D3     156 NOTE: D#3       : Eb3 D#3 ;
  165 NOTE: E3
  175 NOTE: F3     185 NOTE: F#3       : Gb3 F#3 ;
  196 NOTE: G3     208 NOTE: G#3       : Ab3 G#3 ;
  220 NOTE: A3     233 NOTE: A#3       : Bb3 A#3 ;
  247 NOTE: B3
  262 NOTE: C4     277 NOTE: C#4       : Db4 C#4 ;
  294 NOTE: D4     311 NOTE: D#4       : Eb4 D#4 ;
  329 NOTE: E4
  349 NOTE: F4     370 NOTE: F#4       : Gb4 F#4 ;
  392 NOTE: G4     415 NOTE: G#4       : Ab4 G#4 ;
  440 NOTE: A4     466 NOTE: A#4       : Bb4 A#4 ;
  494 NOTE: B4
  523 NOTE: C5     554 NOTE: C#5       : Db5 C#5 ;
  587 NOTE: D5     622 NOTE: D#5       : Eb5 D#5 ;
  659 NOTE: E5
  698 NOTE: F5     740 NOTE: F#5       : Gb5 F#5 ;
  784 NOTE: G5     831 NOTE: G#5       : Ab5 G#5 ;
  880 NOTE: A5     932 NOTE: A#5       : Bb5 A#5 ;
  988 NOTE: B5
 1047 NOTE: C6

: TUNER ( -- ) GEN3 BEGIN 440 HZ -4 DB ?TERMINAL UNTIL MUTE ;

: DMAJOR      122 BPM NORMAL
        GEN1  1/8  D3 E3  F#3 G3 A3 B3  C#4 1/2. D4
              1/4  REST
              1/8  D4 C#4 B3  A3 G3 F#3 E3  1/1  D3 ;

: CHROMATIC   100 BPM  NORMAL
        GEN2  1/8 C3 C#3 D3 D#3 1/16 E3 F3 F#3 G3 G#3 A3 A#3 B3
              1/8 C4 C#4 D4 D#4 1/16 E4 F4 F#4 G4 G#4 A4 A#4 B4
        NORMAL 1/4 C5 ;

: TWINKLE
\     NORMAL
     GEN1   1/8  A3 A3 E4 E4 F#4 F#4   1/4 E4
            1/8  D4 D4 C#4 C#4  B3 B3  1/4 A3
\            STACCATTO
            1/8  E4 E4 D4 D4 C#4 C#4   1/4 B3
\            NORMAL
            1/8  E4 E4 D4 D4 C#4 C#4   1/4 B3
\            MARCATO
            1/8  A3 A3 E4 E4 F#4 F#4   1/4 E4
            1/8  RIT. D4 D4  RIT. C#4  C#4
                 RIT. B3  RIT. B3   RIT. 1/2. A3 ;

: VARIATION
   LEGATO
   GEN1     1/8  A3  C#4  B3  A3  E4  A3  C#4 E4
                 F#4 A4   G#4 F#4 E4  A3  C#4 E4
                 D4  F#4  E4  D4  C#4 E4  D4 C#4
                 B3  A4   B4  F#4 E4  F#4 E4 F#4

                 C#4 E4   C#4 E4  D4  E4  D4  E4
                 C#4 E4   C#4 E4  D4  B3  D4  E4
                 C#4 E4   C#4 E4  D4  E4  D4  E4
                 C#4 E4   C#4 E4  D4  B3  D4  E4

                 A3  C#4  B3  A3  E4  A3  C#4 E4
                 F#4 A4   G#4 F#4 E4  A3  C#4 E4
                 D4  F#4  E4  D4  C#4 E4  D4 C#4
                 RIT. B3  E4  RIT.  F#4 G#4
                 RIT. A4  G#4 RIT. 1/2 A4 ;

92 BPM
NORMAL

