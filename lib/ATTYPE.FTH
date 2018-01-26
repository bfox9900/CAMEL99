\ 10x faster type with x,y placement
\ **WARNING** it does not scroll
DECIMAL

: AT:TYPE ( adr len x y )
          2DUP + C/SCR @ > ABORT" AT:TYPE err."
          AT-XY VPOS SWAP VWRITE ;



