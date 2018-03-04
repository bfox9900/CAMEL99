\ TI sound list player in CAMEL99 Forth
\ 1. This player needs an extra 0  to mark the end of the sound data
\ 2. It turns off all sounds when the data is ended
\ 3. Uses the TMS9901 timer to control sound duration
\    which is used in the Forth word MS. (millisecond delay)

\ : SND!  ( byte -- )  8400 C! ; ( in the CAMEL99 Kernel )

: SILENT ( --)  9F SND!  BF SND!  DF SND! FF SND! ;  \ turn off all sounds

: >MS    ( n -- n') 4 LSHIFT ;  \ n*16, converts ISR delay value to milliseconds

: DURATION@ ( snd$ -- ms) COUNT + C@ ; \ get time byte at end of string

: PLAY$ ( sound_string -- ) \ play 1 sound string
       DUP DURATION@ >MS   \ duration on stack, converted to Milli-secs
       SWAP COUNT          \ returns start address and length of string
       BOUNDS              \ convert addr/len to end-address, start-address
       DO
          PAUSE            \ give time to other tasks
          I C@ SND!        \ feed each byte to sound chip
       LOOP
       ( delay) MS ;       \ use the value we calculated that's on the stack

: NEXTSND  ( snd$ -- )     \ next_string = startaddr + length + 1
            COUNT + 1+ ;

: PLAY ( addr -- )         \ play a list of sound strings
       BEGIN
         DUP C@
       WHILE               \ while the length is not 0
         DUP PLAY$         \ play a single string
         NEXTSND           \ advance to the next sound string
       REPEAT
       SILENT
       DROP ;              \ mom said always clean up after yourself

\ compiler addition to compile string of bytes into memory
: BYTES ( -- )
         BEGIN
            BL WORD COUNT HEAP PLACE   ( heap is un-assigned memory)
            HEAP C@       \ fetch 1st char (string lenght)
         WHILE            \ while the string len>0
            HEAP ?NUMBER 0= ABORT" BAD#"
            DUP FF00 AND ABORT" not a byte"
            C,            \ compile into next byte of memory
         REPEAT ;

: /END   0 , ;            \ compile a zero into memory

\ Ti-99 sound string format
\ <length> <byte(1)> ... <byte(n)>  <duration>  ( duration is in 1/60th seconds)

HEX
CREATE SOUND1   ( Munchman )
       BYTES 08 85 2A 90 A6  08  B0  CC  1F  12
       BYTES 08 85 2A 90 A4  1C  B0  C9  0A  12
/END

CREATE SMACK
       BYTES 4 F2 CC 01 E7 1
       BYTES 2 CC 03 1
       BYTES 2 CC 05 1
/END

CREATE PACMAN
       BYTES 6 86 0D 97 AC 1A B7 8
       BYTES 2 8F 08 2
       BYTES 2 AB 23 5
       BYTES 2 86 0D 4
       BYTES 1 BF 3
       BYTES 2 8E 0B 8
       BYTES 2 8A 0A 2
       BYTES 3 AC 1A B7 8
/END

\ sound lists from Parsec source code

CREATE SHPSND
       BYTES 4 DF FF 93 63 1
       BYTES 4 80 3F AE 3E 60
/END

CREATE EXPLODE
       BYTES 7 9F BF DF E7 F0 C0 07 5
       BYTES 1 F1 6
       BYTES 1 F2 7
       BYTES 1 F3 8
       BYTES 1 F4 9
       BYTES 1 F5 10
       BYTES 1 F6 11
       BYTES 1 F7 12
       BYTES 1 F8 13
       BYTES 1 F9 14
       BYTES 1 FA 15
       BYTES 1 FB 16
       BYTES 1 FC 17
       BYTES 1 FD 18
       BYTES 1 FE 30
       BYTES 1 FF 0
/END

CREATE FIRE
       BYTES 4 9A BF DF FF 1
       BYTES 3 80 0A 98 1
       BYTES 3 80 0C 96 1
       BYTES 3 80 10 94 1
       BYTES 3 80 14 92 1
       BYTES 3 80 18 90 1
       BYTES 3 80 1C 92 1
       BYTES 3 80 20 94 1
       BYTES 3 80 28 96 1
       BYTES 3 80 30 98 1
       BYTES 3 80 38 9A 1
       BYTES 3 80 3E 9C 1
       BYTES 1 9F 0
/END

CREATE CHIME
       BYTES 10 8B 01 A4 02 C5 01 FF 9C BE DE 5
       BYTES 4 A4 02 9E BC 7
       BYTES 3 A7 04 BC 5
       BYTES 3 A4 02 BC 7
       BYTES 8 8B 01 A4 02 C5 01 9C BE 5
       BYTES 4 A4 02 9E BC 7
       BYTES 3 A7 04 BC 5
       BYTES 3 A4 02 BC 7
       BYTES 8 8B 01 A4 02 C5 01 9C BE 5
       BYTES 4 A4 02 9E BC 7
       BYTES 3 A7 04 BC 5
       BYTES 3 A4 02 BC 7
/END

CREATE SW1SND
       BYTES 4 99 B9 DF FF 1
       BYTES 4 80 20 A2 20 10
       BYTES 4 80 21 A2 21 8
       BYTES 4 80 22 A2 22 6
       BYTES 4 80 23 A2 23 4
       BYTES 4 80 24 A2 24 2
/END

CREATE SW2SND
       BYTES 4 96 FB DF FF 1
       BYTES 2 80 30 3
       BYTES 2 80 31 3
       BYTES 2 80 32 3
       BYTES 2 80 33 3
       BYTES 2 80 34 3
       BYTES 2 80 35 3
       BYTES 2 80 36 3
       BYTES 2 80 37 3
       BYTES 2 80 38 3
       BYTES 2 80 39 3
       BYTES 2 80 3A 3
       BYTES 2 80 38 3
       BYTES 2 80 3C 3
       BYTES 2 80 3D 3
       BYTES 2 80 3E 3
       BYTES 2 80 3F 3
/END

CREATE SND123
       BYTES 4 98 B8 DF FF 1
       BYTES 4 80 03 A0 11 1
       BYTES 4 80 05 A0 0F 1
       BYTES 4 80 07 A0 0D 1
       BYTES 4 80 09 A0 0B 1
       BYTES 4 80 0B A0 09 1
       BYTES 4 80 0D A0 07 1
       BYTES 4 80 0F A0 05 1
       BYTES 4 80 11 A0 03 1
/END


CREATE SND4
       BYTES 4 98 BF DF FF 1
       BYTES 2 80 07 1
       BYTES 2 80 06 1
       BYTES 2 80 05 1
       BYTES 2 80 04 1
       BYTES 2 80 05 1
       BYTES 2 80 06 1
       BYTES 2 80 05 1
       BYTES 2 80 04 1
       BYTES 2 80 03 1
       BYTES 2 80 02 1
       BYTES 2 80 01 1
       BYTES 1 9F 0
/END

CREATE FUEL
       BYTES 6 BF DF FF 80 38 93 6
       BYTES 2 80 36 6
       BYTES 2 80 34 6
       BYTES 2 80 32 6
       BYTES 3 80 30 95 6
       BYTES 2 80 2E 6
       BYTES 2 80 2C 6
       BYTES 2 80 2A 6
       BYTES 2 80 28 6
       BYTES 2 80 27 6
       BYTES 2 80 26 6
       BYTES 2 80 25 6
       BYTES 2 80 24 6
       BYTES 2 80 23 5
       BYTES 2 80 22 5
       BYTES 3 80 21 97 4
       BYTES 2 80 20 4
       BYTES 2 80 1F 4
       BYTES 2 80 1E 3
       BYTES 2 80 1D 3
       BYTES 2 80 1C 3
       BYTES 2 80 1B 3
       BYTES 2 80 1A 3
       BYTES 2 80 19 3
       BYTES 2 80 18 3
       BYTES 2 80 17 3
       BYTES 2 80 16 3
       BYTES 2 80 15 3
       BYTES 2 80 14 3
       BYTES 2 80 13 3
       BYTES 2 80 12 3
       BYTES 2 80 11 3
       BYTES 2 80 10 3
/END

: SHOTS  0 ?DO  FIRE PLAY 50 MS LOOP 10 MS EXPLODE PLAY ;



