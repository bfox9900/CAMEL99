\ CAMEL99 Forth Multi-tasking Demo
\ paste into system with mtask99.hsf installed

\ multi-tasker tools
: PULSE  ( -- n)  \ returns round robin transit time
         ~@ PAUSE ~@ - ABS ;   ( ~@ reads 9901 timer)

: .AWAKE        ( ? -- ) IF ." awake"  ELSE ." sleep"  THEN ;

: .LOC  ( adr -- ) LOCAL @ U. SPACE ;

: .TASK  ( pid -- )
         HEX
         CR DUP >R U. SPACE
         R@ 'SP .LOC
         R@ 'RP .LOC
         R@ 'IP .LOC
         R> TFLAG LOCAL @ .AWAKE  ;

: .HDR  ( -- )
         CR ." PID   Pstk  Rstk   IP   Status
         CR ." ----  ----  ----  ----  ------"  ;

: .TASKS ( -- )
       .HDR
       1 >R    \ intial count is 1 (USER0)
       MYSELF
       BEGIN
            TLINK LOCAL @  DUP MYSELF <>
       WHILE
            DUP .TASK
            R> 1+ >R
       REPEAT
       USER0 .TASK
       DROP DECIMAL
       CR R> .  ."  jobs"    \ pull count off Rstack
       CR ." Pulse=" PULSE . ;

: MONITOR  PAGE BEGIN 0 6 AT-XY .TASKS  PAUSE KEY? UNTIL ;


\ DEMO BEGINS

CREATE TASK1   USIZE ALLOT
CREATE TASK2   USIZE ALLOT
CREATE TASK3   USIZE ALLOT
CREATE TASK4   USIZE ALLOT
CREATE TASK5   USIZE ALLOT
CREATE TASK6   USIZE ALLOT

INIT-MULTI

TASK1 FORK
TASK2 FORK
TASK3 FORK
TASK4 FORK
TASK5 FORK
TASK6 FORK

: DREAMS   0 ?DO PAUSE LOOP ;


: .PULSE   \ bar graph of CPU loading
        BEGIN
            1 5 BL  32 HCHAR
            0 5 30  PULSE 32 MOD 1+ 
            DUP 10 > 
            IF    3 10 1 COLOR
            ELSE  3  3 1 COLOR
            THEN  HCHAR
            50 MS
        AGAIN ;


DECIMAL
VARIABLE SPEED  100 SPEED !
VARIABLE Y
\ run for a period of time then  and go to sleep
: JOB1    BEGIN
            100 0
            DO
              -1 Y +! 
              SPEED @ MS
            LOOP
          AGAIN ;


: JOB2
          BEGIN
            90 65
            DO
               31 6 I 15 VCHAR
               30 DREAMS
            LOOP
          AGAIN ;

VARIABLE X
\ run for a period of time then  and go to sleep
: JOB3    BEGIN
            X OFF
            100 0
            DO 
              1 X +! 
              200 MS
            LOOP
          AGAIN ;

DECIMAL
CHAR * CONSTANT '*'
CHAR ! CONSTANT '!'
VARIABLE P
: JOB4
       BEGIN
            0 128 BL VFILL    \ clear top of screen
            100 MS
            C/L @ 4* 1-
            DUP P !
            1- 0
            DO
               '!'   I  VC! 20 MS
               '*'  P @ VC! 20 MS
               -1 P +!
            LOOP
       AGAIN ;

: THING  BEGIN
         17 10
            DO
              5 I    1 COLOR 100 MS
              4 I 1- 1 COLOR 100 MS
            LOOP
         AGAIN ;

 ' JOB1 TASK1 ASSIGN
 ' JOB2 TASK2 ASSIGN
 ' JOB3 TASK3 ASSIGN
 ' JOB4 TASK4 ASSIGN
 ' THING TASK5 ASSIGN
 ' .PULSE TASK6 ASSIGN
\ loading the old TI-99
\ with 6 tasks :-)



