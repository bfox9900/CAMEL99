 \ some string things BASIC doesn't do easily

: SCAN$    ( char $ -- $ position) \ fast 1 char search
             SWAP >R COUNT 2DUP R> SCAN NIP - NIP 1+ ;

: CHARIN       ( char $ -- ?) COUNT ROT SCAN NIP  ;

: -TRAILING  ( adr len -- adr len')  \ remove trailing blanks (spaces)
             1-
             BEGIN  2DUP + C@ BL =      \ test char at end of string (adr+len)
             WHILE  1-                  \ while it is a blank, decrement length
             REPEAT
             1+ ;

: TRIM$    ( $ -- $)      COUNT -TRAILING SPUSH ;    \ trim trailing spaces

: SKIP$    ( $ char -- $ ) >R COUNT R> SKIP SPUSH ;  \ removes leading char

: CLEAN$   ( $ -- $)  COUNT BL SKIP -TRAILING SPUSH ;
