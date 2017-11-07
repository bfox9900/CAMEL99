\ mtask demo

INIT-MULTI

VARIABLE X
VARIABLE Y

CREATE TASK1   USIZE ALLOT
CREATE TASK2   USIZE ALLOT

: THING1  BEGIN   1 X +!  PAUSE AGAIN  ;
: THING2  BEGIN  -1 Y +!  PAUSE AGAIN ;

TASK1 FORK   ( make a copy of USER0 called task1)
TASK2 FORK

' THING1 TASK1 ASSIGN
' THING2 TASK2 ASSIGN

 MULTI       ( enable task switcher)
 TASK1 WAKE
 TASK2 WAKE
 
 X ?
 Y ?
 



