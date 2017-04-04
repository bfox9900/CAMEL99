( CAMEL99 TINY HEAP    Apr 4 2017 BJF )
( simple code for ALLOCATE FREE RESIZE)

HEX                       ( *set* these to your heap)
2000 CONSTANT HEAP        ( using 4k space in Low MEM)
3000 CONSTANT HEND

VARIABLE AP               ( "allocation pointer)

: HHERE       ( - ADR) HEAP AP @ + ;   ( next free HEAP address)
: HALLOT      ( N - )  AP +! ;
: H,          ( N - )  HHERE ! 2 HALLOT ;

: nlink       ( node -- addr) 2-  ;
: nsize       ( node -- n   ) 4 - ;

: LSTNODE     ( -- addr )  HHERE nlink @ ;
: LSTSIZE     ( -- n )     HHERE nsize @ ;

: INIT-HEAP   ( - )   0 AP !  0 H,  HEAP H,  ;
: HFITS?      ( n - )   HHERE + HEND < ;

: (ALLOC)     ( n -- addr ?)
              HHERE DUP >R        (  HHERE is start of the new node, push a copy)
              OVER HALLOT         ( -- n node-start)
              SWAP H, 2- H,       ( compile the size, then the link)
              R> -1 ;             ( return the addr and true)

: ALLOCATE    ( N -- ADDR  ?)
              DUP HFITS? IF (ALLOC)  ELSE  HHERE 0  THEN ;

: FREE      ( -- ?)  ( NON-standard. Only frees last node)
             LSTSIZE CELL+ NEGATE AP +!
             -1 ;

: RESIZE    ( n node -- ?)
            DUP 2- LSTNODE <> ABORT" Can't resize"
            OVER HFITS?
            IF  2DUP nsize @ - HALLOT  ( allot the difference from old * new size)
                nsize !                ( update node size field)
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
400 MALLOC CONSTANT FILEBUF1

S" Now is the time for all good men to come to the aid of their country." A$ PLACE
99 X !
66 Y !
77 X !

: PRINT ( string -- ) COUNT  CR TYPE ;

PAGE A$ PRINT

