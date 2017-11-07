\ VDP RAM STRINGS DEMO

\ NEEDS VHEAP.FTH

: BUFFER:   CREATE   ALLOT  ;

: VPLACE   ( adr len Vadr -- )  2DUP VC! CHAR+ SWAP VWRITE ;
: V$@      ( vadr -- adr len )   DUP VC@ CHAR+ PAD SWAP VREAD PAD COUNT ;

DECIMAL
80 VBUFFER: A$   \ VDP RAM buffer
80  BUFFER: B$   \ CPU RAM buffer


S" This is a string in VDP memory called A$"  A$ VPLACE
S" THIS IS A STRING IN RAM MEMORY CALLED B$"  B$ PLACE

: VTEST  100 0 DO  CR A$ V$@ TYPE  LOOP ;
: RTEST  100 0 DO  CR B$ COUNT TYPE LOOP ;
