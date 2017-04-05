( CAMEL99 TINY HEAP    Apr 4 2017 BJF )
( simple code for ALLOCATE FREE RESIZE)
( Operates similiar to Forth dictionary)

( Apr 5 2017  complete re-think  426 bytes)

( *SET* these CONSTANTs to your heap memory)
HEX
2000 CONSTANT HEAP   ( using 4k space in Low MEM)
3000 CONSTANT HEND

VARIABLE AP       ( allocation pointer)
VARIABLE LSTNODE  ( retains last allocated node address)

: HHERE       ( - ADR) HEAP AP @ + ;   ( next free HEAP address)
: HALLOT      ( N - )  AP +! ;
: H,          ( N - )  HHERE ! 2 HALLOT ;

: NLINK       ( node -- addr) 2-  ;
: NSIZE       ( node -- addr) 4 - ;

: LSTSIZE     ( -- n )   ;

: INIT-HEAP   ( - )
              HEAP 1000 FF FILL ( for debugging)
              0 AP !
              0 H,
              HEAP H,
              HHERE LSTNODE ! ;

: HFITS?      ( n - ) HHERE + HEND < ;

: (ALLOC)     ( n -- addr ?)
              DUP H,
              LSTNODE @ H,
              HHERE DUP LSTNODE !
              SWAP HALLOT
              -1 ;

: ALLOCATE ( N -- addr ?)
            DUP HFITS?
            IF   (ALLOC)
            ELSE  HHERE 0
            THEN ;

: ?NODE    ( node -- ) LSTNODE @ <> ABORT" Not last node" ;

: FREE     ( node -- ?)  ( NON-standard. Only frees last node)
            ?NODE
            LSTNODE @ NSIZE @ 4 + NEGATE HALLOT  -1 ;

: RESIZE   ( n node -- ?)
            DUP ?NODE
            OVER HFITS?
            IF  2DUP NSIZE @ - HALLOT  ( allot the difference from old * new size)
                NSIZE !                ( update node size field)
                -1

            ELSE  0
            THEN ;

INIT-HEAP

( Test code)
: MALLOC ( n -- addr) ALLOCATE 0= ABORT" Malloc failed!"  ;

  2 MALLOC CONSTANT X  ( integers)
  2 MALLOC CONSTANT Y
  2 MALLOC CONSTANT Z
 50 MALLOC CONSTANT A$ ( strings)

99 X !
66 Y !
77 Z !

X ?
X NSIZE ?
A$ NSIZE ?

: PRINT ( string -- ) COUNT  CR TYPE ;

S" Now is the time for all good men to come to the aid of their country." A$ PLACE

PAGE A$ PRINT

