( displayat vaguely familiar to TI Extended BASIC users)
( A fast screen writing word for VDP screen only)

( Usage:  S" Write this string" 5 5 DISPLAYAT )
: DISPLAYAT ( cadr len row col)  AT-XY VPOS SWAP VWRITE ;
