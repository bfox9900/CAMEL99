\ Simple VDP RAM manager
\ Works the same way as the Forth dictionary
\ Best for static allocation

VARIABLE VP    \ VDP memory pointer (4K block)

HEX 1000 VP !   \ start of free VDP RAM

: VHERE   ( -- addr) VP @ ;   \ FETCH the value in VDP pointer
: VALLOT ( n -- )    VP +! ;  \ add n to the value in VDP pointer

\ VDP number "compilers". Put a number or character in VDP RAM 
\ and advance the VP pointer by the proper amount (2 or 1)
: V,     ( n -- )  VHERE V!   2 VALLOT ;
: VC,    ( n -- )  VHERE VC!  1 VALLOT ;

: VCONST:  ( n -- <text>)
            CREATE VHERE , ( n) V,  \ compile time: VDP address in CPU RAM, put n in VDP RAM
            DOES> @ V@ ;            \ run time: fetch the VDP address,
                                    \ then fetch the const from that VDP address

: VAR:     ( -- vaddr)   VHERE CONSTANT    0 V,
: DIM      ( n -- vaddr) VHERE CONSTANT   VALLOT ;

\ create VDP strings
: VPLACE    ( $adr len VDP-adr -- )  2DUP VC! CHAR+ SWAP VWRITE ;  \ place $adr len in VDP-adr
: VS,       ( $adr len-- )  VHERE OVER CHAR+  VALLOT VPLACE ;      \ compile counted string at VHERE
: VCOUNT    ( vdp$adr -- vdpadr len ) DUP 1+ SWAP VC@ ;            \ convert counted string to addr,len
: VTYPE     ( vdp_addr len -- ) BOUNDS ?DO   I VC@ EMIT   LOOP ;

\ collect characters upto final " and put in VDP memory
: ="       ( -- addr len)   [CHAR] " PARSE ROT VPLACE ;

: PRINT   CR VCOUNT VTYPE ;

DECIMAL
80 DIM A$
80 DIM B$
80 DIM C$

A$ =" Now is the time for all good men "
B$ =" to come to the aid of their country."

: TEST 100 0 DO A$ PRINT B$ PRINT LOOP ;




