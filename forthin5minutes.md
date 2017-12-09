( This is the original Forth comment. Notice the required 1st space!)
\ This is the full line comment

( This code came from https://learnxinyminutes.com/docs/forth/ )
( It has been edited/corrected and modified for CAMEL99 Forth )

\ --------------------------------- Preamble -----------------------------------
( ** CAMEL99 Forth is case sensitive. ALL CAMEL99 commands are UPPERCASE **)

\ All Forth commands are separated by a space
\ Forth commands are called WORDS. They are like sub-routines in other languages.
\ WORDs are kept in the Forth Dictionary.

\ In Forth, everything is either a WORD in the dictionary or a number.

\ All programming in Forth is done by using existing WORDs to make new words.

\ Numbers and math are performed on the parameter stack 
( commonly called "the stack")

\ Typing numbers pushes them onto the stack. 1st number is on the bottom.

5 2 3 56 76 23 65    \ ok

( .S prints the stack contents)
.S    \ 5 2 3 56 76 23 65 ok

\ ------------------------------ Basic Arithmetic ------------------------------
\ Arithmetic operators (+,-,*,/ etc) are also just Forth WORDs
\ They operate on numbers sitting on the stack
\ '+' takes two inputs, adds them and leaves the answer on the stack

5 4 +    \ ok  ( looks like nothing happened but 9 is on the stack)

\ The `.` word pops the top item from the stack and prints it:
.    \ 9 ok

\ More examples of arithmetic:
6 7 * .        \ 42 ok
1360 23 - .    \ 1337 ok
12 12 / .      \ 1 ok
13 2 MOD .     \ 1 ok

99 NEGATE .    \ -99 ok
-99 ABS .      \ 99 ok
52 23 MAX .    \ 52 ok
52 23 MIN .    \ 23 ok

\ ----------------------------- Stack Manipulation -----------------------------
\ Naturally, as we work with the stack, we'll need these WORDs:
\                                                               STACK
\                                                               -----
3 DUP            \ duplicate the top item (1st now equals 2nd): 3 3
4 0 DROP .S      \ remove the top item :                        4
1 2 3 NIP .S     \ remove the second item (similar to drop):    1 3
2 5 SWAP .S      \ swap the top with the second element:        5 2
6 4 5 ROT .S     \ rotate the 3rd item to top:                  4 5 6
6 4 5 -ROT .S    \ rotate top item to 3rd position              5 6 4

\ ---------------------- More Advanced Stack Manipulation ----------------------
1 2 3 4 TUCK   \ duplicate the top item below the second slot:     1 2 4 3 4 ok
1 2 3 4 OVER   \ duplicate the second item to the top:             1 2 3 4 3 ok
1 2 3 4  2 PICK \ *duplicate* the item at that position to the top: 1 2 3 4 2 ok

\ When referring to stack indexes, they are zero-based. ( ie: 0 PICK = DUP)

\ ------------------------------ Creating Words --------------------------------
\ The `:` word puts Forth into compile mode until it sees the `;` word.
: SQUARED ( n -- n ) DUP * ;    \ ok
5 SQUARED .                     \ 25 ok

\ WORDs that we create are just added to the dictionary
\ WORDs can be combined with other words to any depth
: 2(X^2) ( n -- n) SQUARED  2 * ; \ returns  2(n^2)

\ -------------------------------- Conditionals --------------------------------
\ TRUE and FALSE are constants in CAMEL99. TRUE returns -1  FALSE returns 0
( However, any non-zero value is also treated as being true)
TRUE .     \ -1 ok
FALSE .    \ 0 ok
42 42 =    \ -1 ok
12 53 =    \ 0 ok

\ `IF` is a compile-only word that does stuff if top of stack is TRUE
\ Syntax: `IF` <stuff to do when TOS is true> `THEN` <rest of program>.
: ?>64 ( n -- n ) DUP 64 > IF ." Greater than 64!" THEN ; \ ok
100 ?>64     \ Greater than 64! ok

\ 'ELSE'
: ?>64 ( n -- n ) DUP 64 > IF ." Greater than 64!" ELSE ." Less than 64!" THEN ;
100 ?>64    \ Greater than 64! ok
20 ?>64     \ Less than 64! ok

\ ------------------------------------ Loops -----------------------------------
\ looping words are compile-only. (must be inside a colon defintion)
: MYLOOP ( -- ) 5 0 DO CR ." Hello!" LOOP ; \ ok
MYLOOP
\ Hello!
\ Hello!
\ Hello!
\ Hello!
\ Hello! ok

\ `DO` expects two numbers on the stack: the end number and the start number.

\ We can get the value of the index as we loop with `i`:
: ONE-TO-12 ( -- ) 12 0 DO I . LOOP ;     \ ok
ONE-TO-12                                 \ 0 1 2 3 4 5 6 7 8 9 10 11 12 ok

\ `?DO` works similarly, except it will skip the LOOP if the end and start
\ numbers are equal.
: SQUARES ( n -- ) 0 ?DO I SQUARE . LOOP ;   \ ok
10 SQUARES                                   \ 0 1 4 9 16 25 36 49 64 81 ok

\ Change the "step" with `+LOOP`:
: THREES ( n n -- ) ?do i . 3 +LOOP ;    \ ok
15 0 THREES                             \ 0 3 6 9 12 ok

\ Indefinite loops with `BEGIN` <stuff to do>  `AGAIN`:
: DEATH ( -- ) BEGIN ." Are we there yet?" AGAIN ;    

\ Conditional loops use 'BEGIN' <stuff to do> <condition> 'UNTIL'
: DECREMENTER ( n -- ) BEGIN 1-  DUP  0= UNTIL ; 

\ WHILE loops use 'BEGIN'  <condition> 'WHILE' <stuff to do> 'REPEAT'
: UPTO10  ( -- ) 0 BEGIN  1+ 10 < WHILE  ." NOT YET"  REPEAT ; 

\ ---------------------------- Variables and Memory ----------------------------

\ Use `VARIABLE` to declare `AGE` to be a variable.
VARIABLE AGE    \ ok

\ VARIABLEs simply give us the address in memory where we can store numbers
( like a pointer but easier to understand)

\ We write 21 to AGE with the word `!` (pronounced "store")
21 AGE !    \ ok

\ We can read the value of our variable using the `@` word called "fetch"
\ '@' just reads the value in an address and puts in the stack
AGE @     \ 21 is sitting on the top of the stack now

\ to print the value on the top of the stack use the '.' command
AGE @ .    \ 21 ok

\ A common tool to fetch and print is '?' which is easy to make with ':'
: ?   ( addr -- )  @ . ;

AGE ?      \ 21 ok

\ Constants work as expected and return their value to the top of stack
100 CONSTANT WATER-BOILING-POINT    \ ok
WATER-BOILING-POINT .               \ 100 ok

\ ----------------------------------- Arrays -----------------------------------
\ Like Assembly language Forth has no standard way to make arrays.

\ We can create arrays by naming a block of memory with the WORD CREATE
\ and allocating memory space with ALLOT.

\ A CELL in Forth is the memory for a single integer
\ CELLS calculates memory size for n CELLS

\ All together it looks like this:
CREATE MYNUMBERS   3 CELLS ALLOT    \ ok

\ Initialize all the values to 0
MYNUMBERS 3 CELLS 0 FILL   \ ok

\ Alternatively we could define ERASE
: ERASE  ( addr len -- ) 0 FILL ;
MYNUMBERS 3 CELLS ERASE

\ or we can CREATE an array initialized with specific values
\ using the 'comma' number compiler. (puts 1 integer in next available memory)
CREATE MYNUMBERS    64 , 9001 , 1337 , \ ok (the last `,` is important!)

\ ...which is equivalent to:

\ Manually writing values to each index:
  64 MYNUMBERS 0 CELLS + !      \ ok
9001 MYNUMBERS 1 CELLS + !    \ ok
1337 MYNUMBERS 2 CELLS + !    \ ok

\ Reading values at certain array indexes the hard way:
MYNUMBERS 0 CELLS + ?    \ 64 ok
MYNUMBERS 1 CELLS + ?    \ 9001 ok

\ We should extend the language by making a helper word for manipulating arrays:
( FORTH lets us use any characters except space as identifier names!)

: [] ( n n -- n ) CELLS + ;    \ ok
MYNUMBERS 2 [] ?               \ 1337 ok

\ Which we can use for writing too:
20 MYNUMBERS 1 [] !    \ ok
   MYNUMBERS 1 [] ?    \ 20 ok

\ ------------------------------ The Return Stack ------------------------------

\ Just like a sub-routine stack, the Forth return stack holds the address (pointer)
\ of the word that called the currently running word.  This lets a Forth Word'return'  
\ to where it came from. 
\ The Return Stack can also be used by the programmer as place to hold numbers 
\ temporarily. In CAMEL99 the return stack also holds the limit and index numbers
\ of any running DO LOOP.  

\ Example: Print 4 numbers in reverse order
: .REVERSE ( n1 n2 n3 n4 -- )  
		>R >R >R               \ push 3 #s onto return stack
		.                      \ print n1, 
		R> . R> . R> .  ;      \ pop the rest and print


\ NOTE: Because Forth uses the return stack internally,  `>R` should
\ always be matched by `R>` inside of your word definitions.
\ Use the return stack carefully!

\ --------------------------------- Final Notes --------------------------------

\ Typing a non-existent word will empty the stack because it calls the word ABORT
\ which resets the data stack and the return stack

\ Clear the screen:
\ PAGE

\ Loading Forth files:
\ INCLUDE MYFILE.FTH

\ With TOOLS.FTH loaded in the system you can list every word that's in Forth's 
\ dictionary.  You can stop the listing by pressing FNCT 4 (CLEAR) on the TI-99.
\ WORDS

\ Exiting CAMEL99 Forth:
\ BYE


