\ ELIZA in CAMEL99 Forth

\ This implementation uses the Forth dictionary as a big case statement
\ Eliza's KEYWORD phrases are converted to Forth words by removing the spaces.

\ Example:
\ "I CAN'T" becomes ICAN'T.  ICAN'T  is a valid FORTH word so all
\ we need is a word in the dictionary called ICAN'T to make something
\ happen.

\ This allows synonyms to be created using a colon definition and adding
\ the new keyword to the KEYWORDS list.
\ Example:  : ICAN'T    ICANNOT  ;
\ The definition for ICANNOT will simply do the same thing as ICAN'T

\ ======[ define helper words ]======
DECIMAL

CHAR ~ CONSTANT '~'   \ strings that end with '~' reflect the users input back

\ working memory for string processing
VARIABLE REPLY$  80 ALLOT    \ holds the "clean" reply from the patient

\
\ --- utility routines ---
\
: $.       ( $ -- ) COUNT TYPE ;                  \ print counted string
: PRINT$   ( $ -- ) CR $. ;                       \ print string on new line
: PROMPT   ( -- )   CR [CHAR] > EMIT BEEP ;       \ show '>' on new line and beep
: $ACCEPT  ( $ -- )  DUP  1+ 80 ACCEPT  SWAP C! ; \ get string input
: LEN      ( $ -- n)  C@ ;                        \ get string length (1st byte)
: LASTCHAR ( $ -- c)  DUP LEN + C@ ;              \ get last char in a string
: COMPARE$ ( $1 $2 -- flag)  OVER LEN 1+ S= ;     \ compare 2 strings
: C+!      ( n addr -- ) DUP >R  C@ +  R> C! ;    \ used to increment a string's byte count
: BETWEEN  ( n min max -- ?)  1+ WITHIN ;         \ is n between or equal-to min/max
: FORALLCHARS ( $ -- end start) COUNT BOUNDS  ;   \ convert $ to 2 addresses for DO LOOP

: END_SESSION  BYE ;                              \ had to rename BYE cuz it's an ELIZA keyword

\
\ --- list help words ---
\
: NEXT$   ( $[1] -- $[2] )   COUNT + ;            \ get next string in a list

: NTH$    ( n list -- $addr )                     \ the nth string in a list
          SWAP 0  DO   NEXT$   LOOP ;

: ITEMS   ( list -- n )                           \ count the no. of items in a list
          0  SWAP
          BEGIN
            NEXT$ DUP LEN 0>
            WHILE
            SWAP 1+ SWAP
          REPEAT
          DROP ;

: LIST[   ( -- ) !CSP  0 C,  ;         \ list starts with 0 bytes, record stack pos.
: ]END    ( -- ) 0 C, ALIGN ?CSP ;     \ '0' ends list, check stack

: "       ( -- )                       \ compile text into memory upto the " char
          [CHAR] " WORD  C@ 1+ ALLOT ;
\
\ --- case testers ---
\
: LOWER?  ( char -- ?)  [CHAR] a [CHAR] z BETWEEN ;
: UPPER?  ( char -- ?)  [CHAR] A [CHAR] Z BETWEEN ;

\
\ --- case covertors ---
\
HEX
: UPPER    ( c -- c ) DUP LOWER? IF  05F AND THEN ;
: LOWER    ( c -- c ) DUP UPPER? IF  020 OR  THEN ;

: TOUPPER  ( $ -- )                             \ convert $ to uppercase
           FORALLCHARS DO  I C@ UPPER I C!  LOOP ;

: LOWER.TYPE ( adr len -- )                     \ print string in lower case
           BOUNDS DO  I C@ LOWER EMIT  LOOP ;

\ ===========[ end of helper words ]=============

DECIMAL
\
\ --- KEYWORDS ---
\
CREATE KEYWORDS
LIST[ " SHIT"      " FRANCAIS"    " DEUTSCH"        " NEDERLANDS"
      " ITALIANO"  " ESPANOL"
      " CAN YOU"   " CAN I"       " YOU ARE"        " YOU'RE"
      " I DON'T"   " I FEEL"      " WHY DON'T YOU"  " WHY CAN'T I"
      " ARE YOU"   " I CAN'T"     " I AM"           " I'M"
      " YOUR"      " I WANT"      " WHAT"           " HOW"
      " WHO"       " WHERE"       " WHEN"           " WHY"
      " NAME"      " CAUSE"       " SORRY"          " DREAM"
      " HELLO"     " HI"          " MAYBE"          " I NEED"
      " ALWAYS"    " THINK"       " ALIKE"          " YOU"
      " YES"       " FRIEND"      " COMPUTER"       " NIL"
      " FUCK"      " ASS"         " ASSHOLE"        " BASTARD"
      " BYE"       " GOODBYE"     " CONSOLE"        " I HAVE"
      " I'VE"      " NO"          " ROBOT"          " REALLY"
]END

\ count all the keywords at compile time
\ and assign the number to the constant #KEYS
KEYWORDS ITEMS CONSTANT #KEYS

: FORALLKEYS (  -- limit start)  #KEYS 1+  1  ;  \ setup for a DO LOOP

: ]KEYWORD ( ndx -- $) KEYWORDS NTH$ ;           \ keyword string array

\ -- debugging word --

: .KEYS    ( -- ) FORALLKEYS  DO   I ]KEYWORD COUNT TYPE [CHAR] , EMIT   LOOP ;

\
\ --- string searching ---
\
: SEARCH$    ( $1 $2 -- ? ) \  is $1 in $2? TRUE/FALSE output
           0 -ROT                     \ put false flag under the inputs
           FORALLCHARS                \ convert $2 to addresses
           DO                         \ loop thru the addresses
             I OVER COUNT S=          \ S= checks for match
             0= IF                    \ if 0 we found a match
                  NIP -1 SWAP         \ remove 0, replace with TRUE
                  LEAVE               \ exit loop early
                THEN
           LOOP
           DROP ;                     \ drop $1 leaving only flag value

: ANALYZE ( -- n )  \ n=keyword no. in REPLY$
           0                       \ start with false flag
           KEYWORDS
           FORALLKEYS
           DO
              NEXT$ DUP REPLY$ SEARCH$
              IF
                 NIP I SWAP       \ replace false flag with Index
                 LEAVE
              THEN
           LOOP
           DROP ;

CREATE ACTION$   32 ALLOT

: NOSPACES  ( $ -- ACTION$)       \ copy $ -> ACTION$ with no spaces
             ACTION$
             0 OVER C!            \ set PAD count to 0
             1+ SWAP              \ adv. to 1st char. addr of action$
             FORALLCHARS          \ convert $ to addresses
             DO
                I C@ DUP          \ read a char
                BL <>             \ test each character
                IF                \ it's upper case alpha
                   OVER C! 1+     \ store in action$, inc action$ addr.
                   1 ACTION$ C+!  \ inc action$ length
                ELSE
                   DROP           \ bad char. drop it
                THEN
             LOOP
             DROP ACTION$ ;

\ convert keyword# into a FORTH word
\ output is a stack string for EVALUATE to use
: >ACTION  ( n -- addr len )
            DUP 0= ABORT" >ACTION ndx err"
            ]KEYWORD NOSPACES COUNT ;    \ non-zero selects keyword


\ ==============================================
\  --- REFLECTIONS ---
\
CREATE PHRASES
LIST[ " ARE"      " AM"
      " WERE"     " WAS"
      " YOU"      " I"
      " YOUR"     " MY"
      " I HAVE"   " YOU'VE"
      " I'VE"     " YOU'VE"
      " I'M"      " YOU'RE"
      " I WILL"   " YOU'LL"
      " I'D"      " YOU WOULD"
      " I'LL"     " YOU WILL"
      " MINE"     " YOURS"
      " ME"       " YOU"
]END

PHRASES ITEMS 1+ CONSTANT #PHRASES

: ]PHRASE ( n -- $) PHRASES NTH$ ; \ phrase string array

: REFLECT ( n -- $) 1+ ]PHRASE ;   \ return the next phrase

: .PHRASES  #PHRASES 1 DO  CR  I DUP ]PHRASE $. 2 SPACES REFLECT $.  2 +LOOP ;

: PHRASE# ( $ -- n )  \ searches for phrase in column 1
           0 SWAP
           #PHRASES 1
           DO
              I ]PHRASE OVER COMPARE$
              0= IF
                    NIP I SWAP  LEAVE
              THEN
           2 +LOOP  \ only scan for the odd values
           DROP  ;

: CONJUGATE ( $ -- $') PHRASE# REFLECT ;


\ ==============================================
\ Replies create a FORTH word with a 2 CELL header structure:

\        --- REPLIES SUPPORT CODE ---
\
: REPLY: ( n -- )
\         name    cnt#  use#  , ... strings ... <nil>
\        -----    ----  ----
 CREATE ( text)  ( n) ,  1  ,   ;

\ given a reply address these words compute the offset of the fields

: ->CNT#    ( replyaddr -- fld_addr)  ;       \ syntax candy
: ->USE#    ( replyaddr -- fld_addr)  CELL+  ;
: ->LIST  ( replyaddr -- fld_addr)  4 + ;
: ->1ST$  ( replyaddr -- $ ) 5 + ;          \ returns 1st string in list
: ->USE$  ( replyaddr -- $ ) ->USE# @ OVER ->LIST NTH$  ;

: LASTONE?  ( replyaddr -- ) 2@ < ;  \ fetch ->CNT# and ->USE# and check if equal

: PRINT.REPLY ( $ -- $ )      \ prints everthing up to the '~' char
              CR CR
              FORALLCHARS
              DO
                  I C@ DUP '~' =
                  IF  DROP LEAVE
                  THEN EMIT
              LOOP ;

\ dot reply prints the reply to "USE" and advances the '->USE#' or resets it to 1
: .REPLY  ( reply_addr -- )
           DUP ->USE$ PRINT.REPLY
           DUP LASTONE?
           IF   1 SWAP ->USE# !
           ELSE 1 SWAP ->USE# +!
           THEN ;

\  =============================
\      === REPLY LISTS ===
\
3 REPLY: CANYOU
LIST[    " Don't you believe that i can~"
         " Perhaps you would like to be able to~"
         " You want me to be able to~"   ]END

2 REPLY: CANI
LIST[    " Perhaps you don't want to~"
         " Do you want to be able to~"  ]END

4 REPLY: YOUARE
LIST[    " What makes you think i am~"
         " Does it please you to believe that i am~"
         " Perhaps you would like to be~"
         " Do you sometimes wish you were~"  ]END

         : YOU'RE  YOUARE ;    \ same replies used for both keys
                               \ so clone it in the dictionary

3 REPLY: IDON'T
LIST[    " Don't you really~"
         " Why don't you~"
         " Do you wish to be able to~" ]END

4 REPLY: IFEEL
LIST[    " Does that trouble you?"
         " Tell me more about such feelings."
         " Do you often feel~"
         " Do you enjoy feeling~" ]END

3 REPLY: IHAVE
LIST[    " How long have you had~"
         " I think that's normal."
         " Many people have~"  ]END
         : I'VE   IHAVE ;

4 REPLY: WHYDON'TYOU
LIST[    " Do you really believe i don't~"
         " Perhaps in good time i will~"
         " Do you want me to~"
         " Do you think you should be able to~" ]END

3 REPLY: WHYCAN'TI
LIST[    " I don't know, why can't you~"
         " Have you really tried to~"
         " You can. you just don't know it yet." ]END

3 REPLY: AREYOU
LIST[    " Why are you interested in whether or not i am~"
         " Would you prefer if i were not~"
         " Perhaps in your fantasies i am~"  ]END

3 REPLY: ICAN'T
LIST[    " How do you know you can't~"
         " Have you tried?"
         " Perhaps you can now~"   ]END

4 REPLY: IAM
LIST[    " Did you come to me because you are~"
         " How long have you been~"
         " Do you believe it is normal to be~"
         " Do you enjoy being~"  ]END

         : I'M   IAM ;

3 REPLY: INEED
LIST[    " Do you really need~"
         " In my experience everybody needs~"
         " What would it mean if you got~"  ]END


3 REPLY: YOU
LIST[    " We were discussing you -- not me."
         " Oh, I~"
         " You're not really talking about me, are you?" ]END

6 REPLY: IWANT
LIST[    " What would it mean if you got~"
         " Why do you want~"
         " Suppose you soon got~"
         " What if you never got~"
         " Sometimes i think i want~"
         " Doesn't everybody?"   ]END

9 REPLY: WHAT
LIST[    " Why do you ask?"
         " Does that question interest you?"
         " What answer would please you the most?"
         " What do you think?"
         " Are such questions on your mind often?"
         " What is it you really want to know?"
         " Have you asked anyone else this question?"
         " Have you asked such questions before?"
         " What else comes to mind when you ask that?" ]END

\ all questions give the same answers
         : HOW    WHAT ;
         : WHO    WHAT ;
         : WHEN   WHAT ;
         : WHERE  WHAT ;
         : WHY    WHAT ;

2 REPLY: NAME
LIST[    " Names don't interest me."
         " I don't care about names. Go on." ]END

4 REPLY: CAUSE
LIST[    " Is that the real reason?"
         " Don't any other reasons come to mind?"
         " Does that reason explain anything else?"
         " What other reason might there be?" ]END

4 REPLY: SORRY
LIST[    " Please don't apologise."
         " Apologies are not necessary."
         " What feelings do you get when you apologise?"
         " Don't be so defensive!" ]END

4 REPLY: DREAM
LIST[    " What does that dream suggest to you?"
         " Do you dream often?"
         " What persons appear in your dreams?"
         " Are you disturbed by your dreams?" ]END

2 REPLY: HELLO
LIST[    " How do you do ... Please state your problem."
         " Hello again :-)"   ]END

         : HI     HELLO ;

5 REPLY: MAYBE
LIST[    " You don't seem quite certain."
         " Why the uncertain tone?"
         " Can't you be more positivE?"
         " You aren't sure?"
         " Don't you know?" ]END

5 REPLY: NO
LIST[    " Are you saying that just to be negative?"
         " You are being a bit negative."
         " Why not?"
         " Are you sure?"
         " Why not?" ]END

2 REPLY: YOUR
LIST[    " Why are you concerned about my~"
         " What about your own~"  ]END

7 REPLY: THINK
LIST[    " Can you think of a specific example?"
         " When?"
         " What are you thinking of?"
         " Really, always?"
         " Do you really think so?"
         " But you are not sure you~"
         " Do you doubt you~"  ]END

6 REPLY: ALIKE
 LIST[   " In what way?"
         " What resemblance do you see?"
         " What does the similarity suggest to you?"
         " What other connections do you see?"
         " Could there really be some connection?"
         " How?" ]END

4 REPLY: YES
LIST[    " You seem quite positive."
         " Are you sure?"
         " I see."
         " I understand." ]END

8 REPLY: FRIEND
LIST[    " Why do you bring up the topic of friends?"
         " Do your friends worry you?"
         " Do your friends pick on you?"
         " Are you sure you have any friends?"
         " Do you impose on your friends?"
         " Perhaps your love for friends worries you?"
         " Do computers worry you?"
         " Are you talking about me in particular?" ]END

6 REPLY: COMPUTER
LIST[    " Are you frightened by machines?"
         " Why do you mention computers?"
         " What do you think computers have to do with your problem?"
         " Don't you think computers can help people?"
         " What is it about machines that worries you?"
         " Say, do you have any psychological problems?"  ]END

3 REPLY: SHIT
LIST[    " Hey now. we don't use that kind of language here."
         " I told you to watch your language!"
         " That's it. I don't have to listen to this!"  ]END

\ all these words cause SHIT to happen :-)
         : FUCK   SHIT ;  : ASS  SHIT ;  : ASSHOLE  SHIT ;  : BASTARD  SHIT ;
         : HELL   SHIT ;  : DICK   SHIT ;

3 REPLY: FRANCAIS
LIST[    " I only work in English."
         " Need I remind you to speak English"
         " Please use English" ]END

         : NEDERLANDS   FRANCAIS ;  \ ALL these words respond the same
         : DEUTSCH      FRANCAIS ;
         : ESPANOL      FRANCAIS ;
         : ITALIANO     FRANCAIS ;
         : JE           FRANCAIS ;
         : ICH          FRANCAIS ;
         : HABLA        FRANCAIS ;
         : PARLEZ       FRANCAIS ;
         : SPRECHEN     FRANCAIS ;

3 REPLY: ROBOT
LIST[    " I am not a ROBOT. I am a human Phsychotherapist"
         " Do you have a ROBOT fetish?"
         " Does it matter if I am a ROBOT?" ]END

3 REPLY: REALLY
LIST[    " Yes really. :-)"
         " I have no reason to be dishonest with you."
         " You don't trust me yet do you?" ]END


6 REPLY: TAPDANCE   \ what you do when you don't know what else to do
LIST[    " What does that suggest to you?"
         " I see."
         " I'm not sure I understand you fully."
         " Can you clarify your thoughts on that?"
         " Can you expand on that a bit?"
         " That is quite interesting. Tell me more. "
         " Sometimes I wonder if you are speaking English."  ]END

: BYE    CR ." OK. Thanks for chatting."
         CR ." Bye bye!"  1000 MS
         CR ." ...Oh and by the way..."  2000 MS
         CR
         CR ." You're CRAZY!" 1500 MS
         END_SESSION ;

         : GOODBYE   BYE ;

: CONSOLE   CR CR  ." CAMEL99 FORTH" CR  QUIT ;

: GREETING  ( -- )
            CR ." Hi! My name is Eliza."
            CR ." Can I help you?" ;

: LISTEN   ( -- )
           BEGIN
             PROMPT  PAD $ACCEPT
             PAD LEN 0>
           UNTIL
           PAD DUP TOUPPER COUNT REPLY$ PLACE ;

VARIABLE K   \ keyword index storage

: .REFLECTION ( $ -- $)
             LASTCHAR '~' =
             IF
                  REPLY$ COUNT  K @ ]KEYWORD LEN  /STRING LOWER.TYPE ." ?"
             THEN ;

HEX
: BLACK/BROWN ( -- ) 1B 7 VWTR ;

DECIMAL
: ELIZA    ( -- )
        TEXT  BLACK/BROWN
        GREETING
        BEGIN
           LISTEN  ANALYZE  K !  \ record the keyword# as K
           K @ 0=
           IF   TAPDANCE .REPLY

           ELSE K @ >ACTION ( -- adr len)
                EVALUATE  ( list) DUP ->USE$ >R
                CR .REPLY
                R> .REFLECTION

           THEN SHIT LASTONE? IF BYE THEN
        AGAIN ;
