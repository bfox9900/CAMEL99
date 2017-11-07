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

BIN" 01111100" ><
BIN" 10000010" +
BIN" 10101010" ><
BIN" 10000010" +
BIN" 10101010" ><
BIN" 10010010" +
BIN" 01000100" ><
BIN" 00111000" +   128 CHARDEF

BIN" 11110000" ><  ( Lower case z)
BIN" 11110000" +
BIN" 11110000" ><
BIN" 00001111" +
BIN" 00001111" ><
BIN" 00001111" +
BIN" 11110000" ><
BIN" 00001111" +   122 CHARDEF

122 EMIT
