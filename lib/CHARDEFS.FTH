( character definition example using BIN" from GRAPHICS )

( requires GRAPHICS.FTH)

BIN" 11111111" ><   ( swap this byte to other side: 00FF becomes FF00 )
BIN" 11111111" +    ( add this byte to the previous one to create a 16bit number) 
BIN" 11000011" ><
BIN" 11000011" +
BIN" 11000011" ><
BIN" 11000011" +
BIN" 11111111" ><
BIN" 11111111" +   127 CHARDEF

BIN" 01111110" ><
BIN" 10000001" +
BIN" 10100101" ><
BIN" 10000001" +
BIN" 10100101" ><
BIN" 10011001" +
BIN" 10000001" ><
BIN" 01111110" +   128 CHARDEF

