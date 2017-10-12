\ BREAK    simple word to exit a program to Forth

\ you can put this word in any loop and stop it 
\ by pressing CTRL C .  
\ ^C? is 4 times faster than KEY?

: BREAK   ^C?  ABORT" ^C pressed"  ;