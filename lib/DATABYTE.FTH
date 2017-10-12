\ DATA and BYTE directive with comma delimiting
\ More compatible with ASM DATA statements

\ Usage:
\ HEX
\ DATA DEAD,BEEF,AABB,
\ DATA 0001,2200,3300,4440,

: BYTES ( -- )
         BEGIN
            [CHAR] , WORD COUNT HEAP PLACE
            HEAP C@
         WHILE
            HEAP ?NUMBER 0= ABORT" BAD#"
            C,
         REPEAT ;

: DATA ( -- )
         BEGIN
            [CHAR] , WORD COUNT HEAP PLACE
            HEAP C@
         WHILE
            HEAP ?NUMBER 0= ABORT" BAD#"
            ,
         REPEAT ;