\ GRAPHICS mode with and color control words for CAMEL99  BJF 21MAR17

\ TI-BASIC color values are the machine values + 1
\ CAMEL99 values are the same as TI BASIC
\
\ Code  Color
\  1    Transparent          9    Medium Red
\  2    Black               10    Light Red
\  3    Medium Green        11    Dark Yellow
\  4    Light Green         12    Light Yellow
\  5    Dark Blue           13    Dark Red
\  6    Light Blue          14    Magenta
\  7    Dark Red            15    Gray
\  8    Cyan                16    White
\

HEX
( =============================================================
( H E L P E R   W O R D S )

 0800 CONSTANT PDT           ( VDP address of "pattern descriptor table")

( value checking words. They ABORT to Forth with a msg if input is bad)
: ?MODE  ( n -- ) VMODE @ <> ABORT" Video mode" ;
: ?COLOR ( n -- n ) DUP 0 10 WITHIN 0= ABORT" color #" ;
: ?EOSCR ( vdpadr -- ) C/SCR @ > ABORT" off screen" ;

(  TI hardware needs colors combined into 1 byte. This word does it)
: >BYTE  ( nibble nibble -- byte ) 04 LSHIFT + ;

( takes fg nibble, bg nibble, convert to TI hardware #s)
( test for legal values, and combine into 1 byte)
: >COLR ( fg bg -- byte) 1- ?COLOR SWAP 1- ?COLOR >BYTE ;

: >VPOS ( row col -- VPOS)  C/L @ * +  ;  ( calc VDP address from row & col)


( NOT IN TI-BASIC: Changes to familiar CYAN screen)
: GRAPHICS  ( -- )
             0 300 BL VFILL     ( clear screen image VDP RAM)
             300 80 0 VFILL     ( erase the color table)
             380 20 F4 VFILL    ( I forget what this does :-)
             20 C/L!            ( 32 chars/line)
             E0 KTP C!          ( KSCAN re-writes VDP Reg1 with whatever is in this byte)
             E0 1 VWTR          ( VDP register 1  bit3 = 0 = Graphics Mode)
             1 6 VWTR           ( set sprite descriptor table to 1x$800=$800)
             7 7 VWTR           ( VDP register 7 set to 7 ie: cyan border)
             CTAB 20 17 VFILL   ( set entire color table to black on cyan [1,7])
             3A0  20  0 VFILL   ( clean up the mess in VDP Ram from Text mode)
             1 VMODE !          ( we'll call this video mode 1 )
             PAGE ;

( =============================================================)
( T I - B A S I C   S U B - P R O G R A M S   B e g i n )

: CLEAR  ( -- )  PAGE  0 17 AT-XY  ;   ( just because you love it )

: COLOR  ( character-set fg-color bg-color  -- )
         1 ?MODE  >COLR SWAP CTAB +  VC! ;

( *NEW* "COLORS" changes all the character sets at once)
: COLORS  ( fg bg -- ) 1 ?MODE  >COLR CTAB 20 ROT VFILL ;

: SCREEN ( color -- )
         1 ?MODE             ( check for MODE 1 )
         1- ?COLOR           ( convert TI-BASIC# to VDP# and test if valid)
         DUP  7 VWTR         ( set screen colour in Video register 7)
         CTAB VC@  F0 AND    ( read 1st CLR TABLE byte, mask out BG color to get FG color)
         +                   ( add the FG color to the new screen BG to make a byte)
         CTAB 20 ROT VFILL ; ( fill the whole color table with this byte)


( CHAR sub-program is renamed to CHARDEF)
: CHARDEF  ( FFFF FFFF FFFF FFFF char# --)
         3 LSHIFT PDT + >R   ( calc address of char# and push. 3 lshift is 4X faster than 8 * )
         R@ 6 + V!           ( nums come off stack in reverse order, so store last ones 1st)
         R@ 4 + V!           ( faster than using a loop for only 4 iterations)
         R@ 2+ V!
         R>    V! ;

: GCHAR ( row col -- char)  >VPOS VC@ ;

( ** NOTE: for HCHAR & VCHAR you must give the number of repititions )
: HCHAR  ( row col char cnt -- ) ( parameter order not ideal so we shuffle)
          SWAP >R >R             ( swap char & cnt, push to return stack)
          >VPOS                  ( -- vadr )
          R> 2DUP  + ?EOSCR      ( bring back count add to Vadr and see if it's too many)
          R>  VFILL ;            ( bring back char and FILL Video memory)

: VCHAR  ( x y char cnt -- ) ( parameter order not ideal so we shuffle)
         >R >R               ( -- x y ) ( push char & cnt to rstack)
         >VPOS               ( -- vdpaddr)  ( calc the Video position in memory)
         R> SWAP             ( -- char vadr) ( get the char and reverse order)
         R> 0                ( -- char vadr cnt index) ( all that crap to get this)
         ?DO                 ( -- char vadr) ( let 'er rip)
            2DUP VC!         ( write char to video memory)
            C/L @ +          ( calc.  next row)
            DUP ?EOSCR       ( did we go too far?)
          LOOP
          2DROP ;
DECIMAL


