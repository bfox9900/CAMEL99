( VALUEs for CAMEL99 )

( usage:  0 VALUE W  )
(        99 TO W )

: VALUE   CONSTANT ;   ( syntax sugar )

: (TO)    ( n <text> -- ) >BODY ! ;

: TO      ( n -- )
           STATE @
           IF   POSTPONE [']  POSTPONE (TO) \ compiling action
           ELSE '  (TO)                     \ interpret action
           THEN ; IMMEDIATE

\ : (+TO)   ( n <text> -- ) >BODY +! ;

\ : +TO      ( n -- )
\           STATE @
\           IF   POSTPONE [']  POSTPONE (+TO) \ compiling action
\           ELSE '  (+TO)                     \ interpret action
\           THEN ; IMMEDIATE

