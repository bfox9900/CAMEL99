( CAMEL99 TINY HEAP    )

( memory structure     )
(   null, heap         )
(   allocated mem ...  )
(   size , link1        ) ( link1 contains addr of HEAP)
\   next allocation ...
\ each allocated chunk also consumes 2 cells: size, link
\ link holds address of previous chunk

2000 CONSTANT HEAP
3000 CONSTANT HEND

VARIABLE AP               ( "allocation pointer)

: HHERE       ( - ADR)  HEAP AP @ + ;   ( next free HEAP address)
: HALLOT      ( N - )    AP +! ;
: H,          ( N - )   HHERE ! 2 HALLOT ;

: nlink       ( node -- addr) 2-  ;
: nsize       ( node -- n   ) 4 -  ;

: LSTNODE     ( -- addr )  HHERE nlink @ ;
: LSTSIZE     ( -- n )     HHERE nsize @ ;

: INIT-HEAP   ( - ) 0 AP !  0 H,  HEAP H,  ;
: HFITS?      ( n - )   HHERE + HEND < ;

: (ALLOC)     ( n -- addr ?)
              HHERE DUP >R        (  HHERE is start of the new node, push a copy)
              OVER HALLOT         ( -- n node-start)
              SWAP H, 2- H,       ( compile the size, then the link)
              R> -1 ;             ( return the addr and true)

: ALLOCATE    ( N -- ADDR  ?)
              DUP HFITS? IF (ALLOC)  ELSE  HHERE 0  THEN ;

: MALLOC ( n -- addr) ALLOCATE 0= ABORT" Malloc failed!"  ;

: FREE      ( -- ?)  ( NON-standard. Only frees last node)
             LSTSIZE CELL+ NEGATE AP +!
             -1 ; 

: RESIZE    ( n node -- ?)
            DUP 2- LSTNODE <> ABORT" Can't resize"
            OVER HFITS?
            IF
               2DUP nsize @ - HALLOT  ( allot the difference from old * new size)
               nsize !                ( update node size field)
               -1
            ELSE
                0
            THEN ;

INIT-HEAP

2 MALLOC CONSTANT X
2 MALLOC CONSTANT Y
2 MALLOC CONSTANT Z



