\ DATA and BYTE directive with comma delimiting
\ More compatible with ASM DATA statements

\ Usage:
\ HEX
\ DATA DEAD,BEEF,AABB,
\ DATA 0001,2200,3300,4440,

: HEAP  ( -- addr) H @ ;
: ?DATA ( -- ) 0= ABORT" Bad#" ;

: BYTE ( -- )
         BEGIN
            [CHAR] , WORD COUNT HEAP PLACE
            HEAP C@
         WHILE
            HEAP ?NUMBER ?DATA C,
         REPEAT ;

: DATA ( -- )
         BEGIN
            [CHAR] , WORD COUNT HEAP PLACES
            HEAP C@
         WHILE
            HEAP ?NUMBER ?DATA ,
         REPEAT ;
