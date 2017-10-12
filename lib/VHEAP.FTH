\ VHEAP   use to manage VDP RAM.
\ Works the same way as the Forth dictionary
\ Best for static allocation

VARIABLE VP    \ VDP memory pointer (4K block)

HEX 1000 VP !   \ start of free VDP RAM

: VHERE   ( -- addr) VP @ ;   \ FETCH the value in VDP pointer
: VALLOT ( n -- )    VP +! ;  \ add n to the value in VDP pointer

\ VDP number "compilers". Put a number in VDP RAM & advance the pointer
: V,     ( n -- )  VHERE V!   2 VALLOT ;
: VC,    ( n -- )  VHERE VC!  1 VALLOT ;


: VPLACE    ( $adr len VDP-adr -- )  2DUP VC! CHAR+ SWAP VWRITE ;  \ place $adr len in VDP-adr
: VS,       ( $adr len-- )  VHERE OVER CHAR+  VALLOT VPLACE ;      \ compile counted string at VHERE
: VCOUNT    ( vdp$adr -- vdpadr len ) DUP 1+ SWAP VC@ ;            \ get length and 1st char of vdp$

: VBUFFER:  CREATE  VHERE ,        \ compile VDP address in the Forth word (in CPU RAM)
            DOES> @ ;              \ at run time fetch the VDP address and put on stack

: VCONST:  ( n -- <text>)           
            CREATE VHERE , ( n) V,  \ compile VDP address in CPU RAM, put n in VDP RAM
            DOES> @ V@ ;            \ run time: fetch the VDP, then fetch the const from VDP RAM

: VAR:     ( -- <text>)
            CREATE VHERE , 0 V,
            DOES> @ ;

: VDP$:    ( $adr len -- )
            CREATE  VHERE ,        \ compile the VHERE address in this word
                    VS,            \ write our stack string into VDP RAM
            DOES> @ VCOUNT ;       \ fetch the VDP $addr and the length

: VTYPE     ( vdp_addr len -- ) BOUNDS ?DO   I VC@ EMIT   LOOP ;

S" A handful of horrors, thrillers and a dash of drama arrive on your Netflix streaming channel." VDP$: A$

S" The highly anticipated second seasons of Stranger Things and Riverdale have many fans excited." VDP$: B$

S" Netflix also offers new original movies, documentaries and series that will keep you entertained." VDP$: C$


\ VDP RAM map with Editor/Assembler

\ *NOTE: if you don't use FILES you can use >1000 to >3FFF for data
\        AND you have 32 bytes >3A0 and 32 bytes at >780  that are free in CAMEL99

\ >0000 +-------------------------+ <--- VR2=00, VR6=00
\       | Screen image table      |
\       | (also sprite patterns)  |
\       |                         |
\ >0300 +-------------------------+ <--- VR5=06
\       | Sprite attributes table |
\ >0380 +-------------------------+ <--- VR3=0E
\       | Color table             |
\ >03A0 +-------------------------+
\       |        (free)           |
\ >03C0 +-------------------------+
\       | VDP roll-out area       |
\ >0400 +-------------------------+
\       |                         |
\       | Sprite patterns >80-F0  |
\       |                         |
\ >0780 +-------------------------+
\       | Sprite motion table     |
\ >0800 +-------------------------+ <--- VR4=01
\       |                         |
\       | Character pattern table |
\       |                         |
\ >1000 +-------------------------+
\       | PAB for most files      |
\ >1080 +-------------------------+
\       | Data are for above PAB  |
\ >10D0 +-------------------------+
\       |        (free)           |
\ >1100 +-------------------------+
\       | PAB for object files    |
\ >1180 +-------------------------+
\       | Data are for above PAB  |
\ >12D0 +-------------------------+
\       |        (free)           |
\ >1300 +-------------------------+
\       | PAB for print files     |
\ >1380 +-------------------------+
\       | Data area for above PAB |
\ >15D0 | and for "program" files |
\       |                         |
\ >3580 +-------------------------+
\       |        (free)           |
\ >35D2 +-------------------------+ <--- @>8370
\       | File buffers (4 files)  |
\ >37D8 +-------------------------+ <--- @>8370
\       | File buffers (3 files)  |
\ >3FFF +-------------------------+ VR0=0, VR1=E0, VR7=F5

