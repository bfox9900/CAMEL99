\ DEFER with Forth 2012 extensions
\ this is much bigger than it needs to be but shown for academic purposes.
\ taken from  http://forth-standard.org/standard/core/IS

: DEFER!  ( xt2 xt1 -- )  >BODY ! ;

: DEFER@  ( 'deferred -- xt)  >BODY @ ;

: IS      ( xt "<spaces>name" -- )
           STATE @
           IF    POSTPONE ['] POSTPONE DEFER!
           ELSE  ' ( -- XT) DEFER!
           THEN ; IMMEDIATE


: ?DEFER  ( -- ) TRUE ABORT" Undefined DEFER"  ;  ( halt if not re-defined )

: DEFER   ( -- <text>)
          CREATE ['] ?DEFER ,     ( ?defer is the default action)
          DOES> @ EXECUTE ;

\ Forth 2012 addition this can be commented out if not needed
: ACTION-OF  ( <text> -- xt) ( returns execution token of <text>)
           STATE @
           IF     POSTPONE [']  POSTPONE DEFER@
           ELSE   ' ( -- XT) DEFER@  ( DEFER@ )
           THEN ; IMMEDIATE
